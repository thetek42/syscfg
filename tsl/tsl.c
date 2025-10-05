#include <assert.h>
#include <errno.h>
#include <mpd/client.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdnoreturn.h>
#include <string.h>
#include <time.h>

#define INTERVAL_SECS 5
#define BATTERY "BAT0"

static void print_contents (void);
static void print_battery (void);
static void print_cpu (void);
static void print_mem (void);
static void print_mpd (void);
static void print_time (void);
static int scanf_file (const char *filename, const char *fmt, ...);
static int find_and_scanf (FILE *fp, const char *key, const char *fmt, void *res);
static void handle_mpd_error (void);
static void terminate (int signo);
static noreturn void die (const char *fmt, ...);

static volatile sig_atomic_t should_exit = 0;
static struct mpd_connection *mpd = NULL;

int
main (void)
{
	struct timespec start, current, diff;
	struct sigaction sig_action;

	/* setup signal handlers */
	memset (&sig_action, 0, sizeof sig_action);
	sig_action.sa_handler = terminate;
	sigaction (SIGINT, &sig_action, NULL);
	sigaction (SIGTERM, &sig_action, NULL);
	sig_action.sa_flags |= SA_RESTART;
	sigaction (SIGUSR1, &sig_action, NULL);

	/* try to connect to mpd */
	mpd = mpd_connection_new (NULL, 0, 1000);
	if (mpd_connection_get_error (mpd) != MPD_ERROR_SUCCESS)
		handle_mpd_error ();

	/* main loop */
	while (!should_exit) {
		if (clock_gettime (CLOCK_MONOTONIC, &start) < 0)
			die ("clock_gettime");

		print_contents ();

		if (ferror (stdout)) die ("print stdout");
		if (should_exit) break;

		/* calculate remaining time to match interval (kind of) */
		if (clock_gettime (CLOCK_MONOTONIC, &current) < 0)
			die ("clock_gettime");
		diff.tv_sec = INTERVAL_SECS - (current.tv_sec - start.tv_sec);
		diff.tv_nsec = 0;
		if (diff.tv_sec <= 0) continue;
		if (nanosleep (&diff, NULL) < 0 && errno != EINTR)
			die ("nanosleep");
	}

	if (mpd) mpd_connection_free (mpd);
}

static void
print_contents (void)
{
	printf (" ");
	print_mpd ();
	print_cpu ();
	printf (" | ");
	print_mem ();
	printf (" | ");
	print_battery ();
	printf (" | ");
	print_time ();
	printf (" \n");
	fflush (stdout);
}

static void
print_battery (void)
{
	const char *filename;
	int perc;

	filename = "/sys/class/power_supply/" BATTERY "/capacity";
	if (scanf_file (filename, "%d", &perc) != 1) goto err;
	printf ("bat %02d", perc);
	return;

err:	printf ("bat N/A");
}

static void
print_cpu (void)
{
	static uintmax_t a[7] = {0};
	uintmax_t b[7], perc, sum;

	memcpy (b, a, sizeof b);
	if (scanf_file ("/proc/stat", "%*s %ju %ju %ju %ju %ju %ju %ju",
	                 &a[0], &a[1], &a[2], &a[3], &a[4], &a[5], &a[6]) != 7)
		goto err;
	if (b[0] == 0) goto err;
	sum = (a[0] + a[1] + a[2] + a[3] + a[4] + a[5] + a[6]) -
	      (b[0] + b[1] + b[2] + b[3] + b[4] + b[5] + b[6]);
	if (sum == 0) goto err;
	perc = (a[0] + a[1] + a[2] + a[5] + a[6]) - (b[0] + b[1] + b[2] + b[5] + b[6]);
	perc = (100 * perc) / sum;
	printf ("cpu %02ju", perc);
	return;

err:	printf ("cpu N/A");
}

static void
print_mem (void)
{
	uintmax_t total, free, buffers, cached, shmem, sreclaim, perc;
	FILE *file;

	file = fopen ("/proc/meminfo", "r");
	if (!file) goto err;
	if (find_and_scanf (file, "MemTotal:", "%ju kB", &total) != 1 ||
	    find_and_scanf (file, "MemFree:", "%ju kB", &free) != 1 ||
	    find_and_scanf (file, "Buffers:", "%ju kB", &buffers) != 1 ||
	    find_and_scanf (file, "Cached:", "%ju kB", &cached) != 1 ||
	    find_and_scanf (file, "Shmem:", "%ju kB", &shmem) != 1 ||
	    find_and_scanf (file, "SReclaimable:", "%ju kB", &sreclaim) != 1)
		goto err;
	fclose (file);
	if (total == 0) goto err;
	perc = total + shmem - free - buffers - cached - sreclaim;
	perc = (100 * perc) / total;
	printf ("mem %02ju", perc);
	return;

err:	if (file) fclose (file);
	printf ("mem N/A");
}

static void
print_mpd (void)
{
	struct mpd_song *song;
	const char *value;

	if (!mpd) return;

	mpd_command_list_begin (mpd, true);
	mpd_send_current_song (mpd);
	mpd_command_list_end (mpd);
	if (mpd_connection_get_error (mpd) != MPD_ERROR_SUCCESS) {
		handle_mpd_error ();
		return;
	}

	if ((song = mpd_recv_song (mpd))) {
		printf ("♫ ");
		if ((value = mpd_song_get_tag (song, MPD_TAG_ARTIST, 0))) {
			printf ("%.15s", value);
			if (strlen (value) > 15) printf ("…");
		} else {
			printf ("n/a");
		}
		printf (" - ");
		if ((value = mpd_song_get_tag (song, MPD_TAG_TITLE, 0))) {
			printf ("%.31s", value);
			if (strlen (value) > 31) printf ("…");
		} else {
			printf ("n/a");
		}
		printf (" | ");
		mpd_song_free (song);
	}

	if ((mpd_connection_get_error (mpd) != MPD_ERROR_SUCCESS) ||
	    (!mpd_response_finish (mpd))) {
		handle_mpd_error ();
	}
}

static void
print_time (void)
{
	char buf[18];
	time_t t;
	t = time (NULL);
	strftime (buf, sizeof buf, "%F %H:%M", localtime (&t));
	printf ("%s", buf);
}

static int
scanf_file (const char *filename, const char *fmt, ...)
{
	FILE *file;
	va_list ap;
	int ret;

	file = fopen (filename, "r");
	if (!file) return -1;
	va_start (ap, fmt);
	ret = vfscanf (file, fmt, ap);
	va_end (ap);
	fclose (file);
	return ret;
}

static int
find_and_scanf (FILE *fp, const char *key, const char *fmt, void *res)
{
	char line[256];
	int n = -1;

	rewind(fp);
	while (fgets(line, sizeof(line), fp)) {
		if (strncmp(line, key, strlen(key)) == 0) {
			n = sscanf(line + strlen(key), fmt, res);
			break;
		}
	}
	return (n == 1) ? 1 : -1;
}

static void
handle_mpd_error (void)
{
	fprintf (stderr, "%s\n", mpd_connection_get_error_message (mpd));
	mpd_connection_free (mpd);
	mpd = NULL;
}

static void
terminate (int signo)
{
	if (signo != SIGUSR1) {
		should_exit = 1;
	}
}

static noreturn void
die (const char *fmt, ...)
{
	va_list ap;
	fprintf (stderr, "error: ");
	va_start (ap, fmt);
	vfprintf (stderr, fmt, ap);
	perror ("errno");
	va_end (ap);
	exit (1);
}
