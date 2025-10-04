#include <errno.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdnoreturn.h>
#include <string.h>
#include <time.h>

#define INTERVAL_SECS 10
#define BATTERY "BAT0"

static void print_contents (void);
static void print_battery (void);
static void print_time (void);
static void terminate (int signo);
static noreturn void die (const char *fmt, ...);

static volatile sig_atomic_t should_exit = 0;

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

	/* main loop */
	while (!should_exit) {
		if (clock_gettime (CLOCK_MONOTONIC, &start) < 0) {
			die ("clock_gettime");
		}

		print_contents ();
		if (ferror (stdout)) {
			die ("print stdout");
		}
		if (should_exit) break;

		/* calculate remaining time to match interval (kind of) */
		if (clock_gettime (CLOCK_MONOTONIC, &current) < 0) {
			die ("clock_gettime");
		}
		diff.tv_sec = INTERVAL_SECS - (current.tv_sec - start.tv_sec);
		diff.tv_nsec = 0;
		if (diff.tv_sec <= 0) continue;
		if (nanosleep (&diff, NULL) < 0 && errno != EINTR) {
			die ("nanosleep");
		}
	}
}

static void
print_contents (void)
{
	printf (" ");
	print_battery ();
	printf (" | ");
	print_time ();
	printf (" \n");
	fflush (stdout);
}

static void
print_battery (void)
{
	FILE *file;
	int perc;
	
	file = fopen ("/sys/class/power_supply/" BATTERY "/capacity", "r");
	if (!file) goto err;
	if (fscanf (file, "%d", &perc) != 1) goto err;
	fclose (file);
	printf ("BAT: %02d%%", perc);
	return;

err:	if (file) fclose (file);
	printf ("BAT: n/a");
}

static void
print_time (void)
{
	char buf[21];
	time_t t;
	t = time (NULL);
	strftime (buf, sizeof buf, "%F %T", localtime (&t));
	printf ("%s", buf);
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
