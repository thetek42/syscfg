VERSION := 1.0
PREFIX  := /usr/local

CC     := gcc
CFLAGS := -std=c99 -Ibuild -ggdb3 -D_POSIX_C_SOURCE=200809L -DVERSION=\"$(VERSION)\"
CFLAGS += -Wall -Wextra -Werror -Wpedantic -Wno-unused

LIBS   := wayland-client xkbcommon
CFLAGS += $(shell pkg-config --cflags $(LIBS))
CLIBS  := $(shell pkg-config --libs $(LIBS)) -lcrypt

WLSCAN  := $(shell pkg-config --variable=wayland_scanner wayland-scanner)
WLPROTO := $(shell pkg-config --variable=pkgdatadir wayland-protocols)
PROTOS  := build/single-pixel-buffer-v1-protocol.h
PROTOS  += build/ext-session-lock-v1-protocol.h
PROTOS  += build/viewporter-protocol.h

SRC_FILES := wlock.c $(PROTOS:.h=.c)
OBJ_FILES := build/wlock.o $(PROTOS:.h=.o) 


all: build/wlock

clean:
	rm -rf build/

install: build/wlock
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f $< $(DESTDIR)$(PREFIX)/bin/wlock
	chmod 4755 $(DESTDIR)$(PREFIX)/bin/wlock

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/wlock

.PHONY: all clean install uninstall


build/wlock: builddir $(OBJ_FILES)
	$(CC) $(CFLAGS) $(OBJ_FILES) -o $@ $(CLIBS)

build/wlock.o: wlock.c
	$(CC) $(CFLAGS) -c $< -o $@
build/%-protocol.o: build/-protocol.c
	$(CC) $(CFLAGS) -c $< -o $@

wlock.c: $(PROTOS)


builddir:
	@mkdir -p build/


build/single-pixel-buffer-v1-protocol.c:
	$(WLSCAN) private-code $(WLPROTO)/staging/single-pixel-buffer/single-pixel-buffer-v1.xml $@
build/single-pixel-buffer-v1-protocol.h:
	$(WLSCAN) client-header $(WLPROTO)/staging/single-pixel-buffer/single-pixel-buffer-v1.xml $@
build/ext-session-lock-v1-protocol.c:
	$(WLSCAN) private-code $(WLPROTO)/staging/ext-session-lock/ext-session-lock-v1.xml $@
build/ext-session-lock-v1-protocol.h:
	$(WLSCAN) client-header $(WLPROTO)/staging/ext-session-lock/ext-session-lock-v1.xml $@
build/viewporter-protocol.c:
	$(WLSCAN) private-code $(WLPROTO)/stable/viewporter/viewporter.xml $@
build/viewporter-protocol.h:
	$(WLSCAN) client-header $(WLPROTO)/stable/viewporter/viewporter.xml $@
