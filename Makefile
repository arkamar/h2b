# See LICENSE file for copyright and license details.

include config.mk

TARGET = h2b

SRC = ${TARGET}.c
OBJ = ${SRC:.c=.o}

all: options h2b

options:
	@echo ${TARGET} build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${TARGET}: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${TARGET}.o ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f ${TARGET} ${OBJ} ${TARGET}-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p ${TARGET}-${VERSION}
	@cp -R LICENSE Makefile config.mk README \
		${TARGET}.1 ${SRC} ${TARGET}-${VERSION}
	@tar -cf ${TARGET}-${VERSION}.tar ${TARGET}-${VERSION}
	@gzip ${TARGET}-${VERSION}.tar
	@rm -rf ${TARGET}-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f ${TARGET} ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/${TARGET}
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < ${TARGET}.1 > ${DESTDIR}${MANPREFIX}/man1/${TARGET}.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/${TARGET}.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/${TARGET}
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/${TARGET}.1

.PHONY: all options clean dist install uninstall
