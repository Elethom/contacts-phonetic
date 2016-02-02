PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

INC = inc
VPATH = src
SRC = main.m
BIN = contacts-phonetic

CC = clang
CFLAGS = -Wall -I$(INC)
DEP = -framework Foundation -framework CoreFoundation -framework AddressBook

$(BIN): $(SRC)
	$(CC) $(CFLAGS) $(DEP) $< -o $@

install: all
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 $(BIN) $(DESTDIR)$(BINDIR)

all: $(BIN)

.PHONY: all
