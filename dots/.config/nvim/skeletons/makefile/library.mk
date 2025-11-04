# --- configuration ------------------------------------------------------------

CC     := gcc
CFLAGS := -std=c99 -Iinc
CFLAGS += -Wall -Wextra -Wpedantic -Wdouble-promotion -Wconversion -Werror
CFLAGS += -Wno-sign-conversion -Wno-attributes -Wno-stringop-truncation
CFLAGS += -Og -ggdb3 -fsanitize=undefined,address,leak -fanalyzer

LIB_SRC    := $(shell find src/ -type f -name "*.c")
LIB_OBJ    := $(LIB_SRC:src/%.c=obj/src/%.o)
LIB_DEP    := $(LIB_SRC:src/%.c=obj/src/%.dep)
LIB_STATIC := bin/lib.a
LIB_CFLAGS :=

EXAMPLES_SRC    := $(shell find examples/ -type f -name "*.c")
EXAMPLES_OBJ    := $(EXAMPLES_SRC:examples/%.c=obj/examples/%.o)
EXAMPLES_DEP    := $(EXAMPLES_SRC:examples/%.c=obj/examples/%.dep)
EXAMPLES_BIN    := $(EXAMPLES_SRC:examples/%.c=bin/example-%)
EXAMPLES_CFLAGS :=
EXAMPLES_CLIBS  :=


# --- phonies ------------------------------------------------------------------

all: $(LIB_STATIC)

clean:
	rm -rf bin/ obj/

examples: $(EXAMPLES_BIN)

.PHONY: all clean examples


# --- rules --------------------------------------------------------------------

$(LIB_STATIC): $(LIB_OBJ)
	@mkdir -p $(@D)
	@echo -e '\x1b[36mAR   \x1b[0m $@'
	@ar rcs $@ $^

bin/example-%: obj/examples/%.o $(LIB_STATIC)
	@mkdir -p $(@D)
	@echo -e '\x1b[36mLINK \x1b[0m $@'
	@$(CC) $(CFLAGS) $(EXAMPLES_CFLAGS) $^ -o $@ $(EXAMPLES_CLIBS)

obj/src/%.o: src/%.c
	@mkdir -p $(@D)
	@echo -e '\x1b[32mCC   \x1b[0m $<'
	@$(CC) $(CFLAGS) $(LIB_CFLAGS) -c $< -o $@ -MD -MP -MF $(<:src/%.c=obj/src/%.dep)

obj/examples/%.o: examples/%.c
	@mkdir -p $(@D)
	@echo -e '\x1b[32mCC   \x1b[0m $<'
	@$(CC) $(CFLAGS) $(EXAMPLES_CFLAGS) -c $< -o $@ -MD -MP -MF $(<:src/%.c=obj/src/%.dep)


# --- dependencies -------------------------------------------------------------

.PRECIOUS: $(EXAMPLES_OBJ)

-include $(LIB_DEP)
-include $(EXAMPLES_DEP)
