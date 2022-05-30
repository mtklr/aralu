# aralu makefile

CC ?= /usr/bin/cc
RM ?= /bin/rm -f
INSTALL ?= /usr/bin/install
INSTALL_DATA ?= $(INSTALL) -m 0644

PREFIX ?= $(PWD)/build
gamesdir = $(PREFIX)/games
datadir = $(PREFIX)/share/$(PROG)
localstatedir = $(PREFIX)/var/games

PROG = aralu
SRC = $(wildcard ./*.c)
OBJ = $(SRC:.c=.o)

SCREEN_FILES = $(wildcard screen.*)

SCORE_FILE = aralu.score
SAVE_FILE = aralu.sav
MON_FILE = monsters.dat
SUPERUSER ?= $(USER)

OPT ?= -O0 -g -Wall -Wextra
CFLAGS += $(OPT) \
	  -DSCOREFILE=\"$(DESTDIR)$(localstatedir)/$(SCORE_FILE)\" \
	  -DSAVEFILE=\"$(DESTDIR)$(SAVE_FILE)\" \
	  -DMONFILE=\"$(DESTDIR)$(datadir)/$(MON_FILE)\" \
	  -DSCREENPATH=\"$(DESTDIR)$(datadir)\" \
	  -DSUPERUSER=\"$(SUPERUSER)\"
LDFLAGS +=
LDLIBS = -lncurses

.PHONY: all
all: $(PROG)

$(PROG): $(OBJ)

.PHONY: clean
clean:
	$(RM) $(PROG)
	$(RM) *.o

.PHONY: install
install: all
	$(INSTALL) -d $(DESTDIR)$(gamesdir)
	$(INSTALL) $(PROG) $(DESTDIR)$(gamesdir)
	$(INSTALL) -d $(DESTDIR)$(datadir)
	$(INSTALL_DATA) $(MON_FILE) $(DESTDIR)$(datadir)
	$(INSTALL_DATA) $(foreach f,$(SCREEN_FILES),$f) $(DESTDIR)$(datadir)
	$(INSTALL) -d $(DESTDIR)$(localstatedir)
	$(INSTALL_DATA) $(SCORE_FILE) $(DESTDIR)$(localstatedir)/$(SCORE_FILE)

.PHONY: uninstall
uninstall:
	$(RM) $(DESTDIR)$(gamesdir)/$(PROG)
	$(RM) $(DESTDIR)$(datadir)/$(MON_FILE)
	$(RM) $(foreach f,$(SCREEN_FILES),$(DESTDIR)$(datadir)/$(f))
	# $(RM) $(DESTDIR)$(localstatedir)/$(SCOREFILE)
