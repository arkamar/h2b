# h2b version
NAME    = h2b
VERSION = 0.0

# Customize below to fit your system

# paths
PREFIX ?= /usr
MANPREFIX = ${PREFIX}/share/man

# flags
CPPFLAGS += -DVERSION=\"${VERSION}\" -D_DEFAULT_SOURCE
CFLAGS ?= -O2 -pipe -Wall -pedantic -march=native
CFLAGS += -std=c99 -pedantic -Wall
