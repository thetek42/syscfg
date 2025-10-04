VERSION = 0.1

CC     := gcc
CFLAGS := -std=c11 -Isrc -Ibuild
CFLAGS += -Wall -Wextra -Wpedantic -Wfloat-conversion -Wdeclaration-after-statement \
	  -Wno-unused-parameter -Wshadow -Wunused-macros -Werror=strict-prototypes \
	  -Werror=implicit -Werror=return-type -Werror=incompatible-pointer-types
CFLAGS += -ggdb3
CFLAGS += -DWLR_USE_UNSTABLE -DXWAYLAND -D_POSIX_C_SOURCE=200809L -DVERSION=\"$(VERSION)\"

LIBS   := wlroots-0.19 wayland-server libinput pixman-1 fcft xkbcommon xcb xcb-icccm
CFLAGS += $(shell pkg-config --cflags $(LIBS))
CLIBS  := $(shell pkg-config --libs $(LIBS)) -lm

WLSCAN  := $(shell pkg-config --variable=wayland_scanner wayland-scanner)
WLPROTO := $(shell pkg-config --variable=pkgdatadir wayland-protocols)
PROTOS  := build/cursor-shape-v1-protocol.h \
	   build/pointer-constraints-unstable-v1-protocol.h \
	   build/xdg-shell-protocol.h build/wlr-layer-shell-unstable-v1-protocol.h \
	   build/wlr-output-power-management-unstable-v1-protocol.h

SRC_FILES := $(shell find src/ -type f -name "*.c")
OBJ_FILES := $(SRC_FILES:src/%.c=build/%.o)
DEP_FILES := $(SRC_FILES:src/%.c=build/%.dep)


all: build/twl

clean:
	rm -rf build/

.PHONY: all clean


build/twl: $(OBJ_FILES)
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(OBJ_FILES) -o $@ $(CLIBS)
build/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@ -MD -MP -MF $(<:src/%.c=build/%.dep)
build/twl.o: $(PROTOS)


build/cursor-shape-v1-protocol.h:
	$(WLSCAN) enum-header $(WLPROTO)/staging/cursor-shape/cursor-shape-v1.xml $@
build/pointer-constraints-unstable-v1-protocol.h:
	$(WLSCAN) enum-header $(WLPROTO)/unstable/pointer-constraints/pointer-constraints-unstable-v1.xml $@
build/xdg-shell-protocol.h:
	$(WLSCAN) server-header $(WLPROTO)/stable/xdg-shell/xdg-shell.xml $@
build/wlr-layer-shell-unstable-v1-protocol.h: protocols/wlr-layer-shell-unstable-v1.xml
	$(WLSCAN) enum-header $< $@
build/wlr-output-power-management-unstable-v1-protocol.h: protocols/wlr-output-power-management-unstable-v1.xml
	$(WLSCAN) server-header $< $@


-include $(DEP_FILES)
