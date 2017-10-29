# See LICENSE file for copyright and license details.

include config.mk

BIN = h2b b2h

SRC = $(BIN:=.c)
MAN = $(BIN:=.1)

all: options $(BIN)

options:
	@echo $(BIN) build options:
	@echo "CFLAGS   = $(CFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CC       = $(CC)"

clean:
	$(RM) $(BIN) $(OBJ) $(NAME)-$(VERSION).tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p $(NAME)-$(VERSION)
	@cp -R LICENSE Makefile config.mk README \
		$(MAN) $(SRC) $(NAME)-$(VERSION)
	@tar -cf $(NAME)-$(VERSION).tar $(NAME)-$(VERSION)
	@gzip $(NAME)-$(VERSION).tar
	@rm -rf $(NAME)-$(VERSION)

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f $(BIN) ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/${TARGET}
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@for i in $(MAN) ; do \
		sed "s/VERSION/${VERSION}/g" < "$$i" > "${DESTDIR}${MANPREFIX}/man1/$$i" ; \
		chmod 644 "${DESTDIR}${MANPREFIX}/man1/$$i" ; \
	done

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/${TARGET}
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@for i in $(MAN) ; do \
		$(RM) "${DESTDIR}${MANPREFIX}/man1/$$i" ; \
	done

.PHONY: all options clean dist install uninstall
