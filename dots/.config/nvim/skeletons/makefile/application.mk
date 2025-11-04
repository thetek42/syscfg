CC     := gcc
CFLAGS := -std=c99 -Iinc
CFLAGS += -Wall -Wextra -Wpedantic -Wdouble-promotion -Wconversion -Werror
CFLAGS += -Wno-sign-conversion -Wno-attributes -Wno-stringop-truncation
CFLAGS += -Og -ggdb3 -fsanitize=undefined,address,leak -fanalyzer
CLIBS  :=

SRC_FILES := $(shell find src/ -type f -name "*.c")
OBJ_FILES := $(SRC_FILES:src/%.c=obj/%.o)
DEP_FILES := $(SRC_FILES:src/%.c=obj/%.dep)

TARGET := bin/target


all: $(TARGET)

clean:
	rm -rf bin/ obj/

.PHONY: all clean


$(TARGET): $(OBJ_FILES)
	@mkdir -p $(@D)
	@echo -e '\x1b[36mLINK \x1b[0m $@'
	@$(CC) $(CFLAGS) $(OBJ_FILES) -o $@ $(CLIBS)

obj/%.o: src/%.c
	@mkdir -p $(@D)
	@echo -e '\x1b[32mCC   \x1b[0m $<'
	@$(CC) $(CFLAGS) -c $< -o $@ -MD -MP -MF $(<:src/%.c=obj/%.dep)


-include $(DEP_FILES)
