/* See LICENSE file for copyright and license details. */

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

#define LENGTH(x) ((sizeof x / sizeof *x))

enum h2b_state {
	H2B_NORMAL,
	H2B_HEX,
};

static inline
char
hex2dec(const char c) {
	if ((unsigned)(c - '0') < 10)
		return c - '0';
	else /* if ((c | 0x20) - 'a' < 6) */ /* c | 0x20 -> to lower */
		return (c | 0x20) - 'a' + 10;
}

static
int
normal(const char c) {
	int ret = H2B_NORMAL;
	if (c == '"' || c == '\'')
		ret = H2B_HEX;
	fwrite(&c, 1, 1, stdout);
	return ret;
}

static
int
hex(const char c) {
	static unsigned char prev, o, i = 1;
	if (c == '"' || c == '\'') {
		fwrite(&c, 1, 1, stdout);
		return H2B_NORMAL;
	}
	if (prev == 0 && c == '\\') {
		prev = c;
	} else if (prev == '\\' && c == 'x') {
		prev = c;
	} else if (prev == 'x' && isxdigit(c)) {
		if (i % 2) {
			o = hex2dec(c) << 4;
		} else {
			o |= hex2dec(c);
			fwrite(&o, 1, 1, stdout);
			prev = 0;
		}
		i++;
	} else {
		fprintf(stderr, "Error: caracter '%c' cannot be here\n", c);
		exit(1);
	}
	return H2B_HEX;
}

int (*callback[])(const char) = {
	normal,
	hex
};

int
main(int argc, char * argv[]) {
	unsigned char c;
	unsigned char state = H2B_NORMAL;

	while (fread(&c, 1, 1, stdin) > 0)
		if (state < LENGTH(callback))
			state = callback[state](c);

	return 0;
}
