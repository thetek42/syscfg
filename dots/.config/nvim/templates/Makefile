CC     := gcc
CFLAGS := -std=c23 -Isrc
CFLAGS += -Wall -Wextra -Werror -Wdouble-promotion -Wconversion -pedantic
CFLAGS += -Wno-sign-conversion -Wno-attributes -Wno-stringop-truncation
CFLAGS += -DDEBUG -Og -ggdb3 -fsanitize=undefined
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
	@echo -e '\x1b[36mLINK \x1b[0m $(TARGET)'
	@$(CC) -shared $(CFLAGS) $(OBJ_FILES) -o $@ $(CLIBS)

obj/%.o: src/%.c
	@mkdir -p $(@D)
	@echo -e '\x1b[32mCC   \x1b[0m $<'
	@$(CC) $(CFLAGS) -c $< -o $@ -MD -MP -MF $(<:src/%.c=obj/%.dep)


-include $(DEP_FILES)
