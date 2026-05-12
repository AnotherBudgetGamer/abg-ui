CC = gcc
AR = ar

CFLAGS = -Wall -Wextra -g -pedantic -std=c99 -Iinclude

BUILD_DIR = build
TARGET = $(BUILD_DIR)/libabg_ui.a

PREFIX ?= /usr/local

SRCS = \
	src/abg_ui.c

OBJS = $(SRCS:src/%.c=$(BUILD_DIR)/%.o)

.PHONY: all install uninstall clean rebuild

all: $(TARGET)

$(TARGET): $(OBJS)
	mkdir -p $(BUILD_DIR)
	$(AR) rcs $(TARGET) $(OBJS)

$(BUILD_DIR)/%.o: src/%.c include/abg_ui.h
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

install: $(TARGET)
	mkdir -p $(PREFIX)/include
	mkdir -p $(PREFIX)/lib
	cp include/abg_ui.h $(PREFIX)/include/
	cp $(TARGET) $(PREFIX)/lib/

uninstall:
	rm -f $(PREFIX)/include/abg_ui.h
	rm -f $(PREFIX)/lib/libabg_ui.a

clean:
	rm -rf $(BUILD_DIR)

rebuild: clean all