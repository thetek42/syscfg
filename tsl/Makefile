CC     := gcc
CFLAGS := -std=c11 -Isrc -ggdb3 -D_POSIX_C_SOURCE=200809L
CFLAGS += -Wall -Wextra -Werror -Wdouble-promotion -Wconversion -Wpedantic
CLIBS  :=

SRC    := tsl.c
BIN    := tsl


all: $(BIN)

clean:
	rm -rf tsl

.PHONY: all clean


$(BIN): $(SRC)
	$(CC) $(CFLAGS) $< -o $@
