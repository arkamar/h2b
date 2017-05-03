/* See LICENSE file for copyright and license details. */

#include <ctype.h>
#include <stdio.h>

#define LENGTH(x) ((sizeof x / sizeof *x))

enum h2b_state {
	H2B_NORMAL,
	H2B_COMMENT,
	H2B_QUOTE,
};

static inline
char
hex2dec(const unsigned char c) {
	if ((unsigned)(c - '0') < 10)
		return c - '0';
	else /* if ((c | 0x20) - 'a' < 6) */ /* c | 0x20 -> to lower */
		return (c | 0x20) - 'a' + 10;
}

static
int
normal(const unsigned char c) {
	static unsigned char o, i = 1;
	if (c == '#')
		return H2B_COMMENT;
	if (c == '"')
		return H2B_QUOTE;
	if (isxdigit(c)) {
		if (i % 2) {
			o = hex2dec(c) << 4;
		} else {
			o |= hex2dec(c);
			fwrite(&o, 1, 1, stdout);
		}
		i++;
	}
	return H2B_NORMAL;
}

static
int
comment(const unsigned char c) {
	return (c == '\n') ? H2B_NORMAL : H2B_COMMENT;
}

static
int
quote(const unsigned char c) {
	if (c == '"')
		return H2B_NORMAL;
	fwrite(&c, 1, 1, stdout);
	return H2B_QUOTE;
}

int (* callback[])(const unsigned char) = {
	normal,
	comment,
	quote
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
