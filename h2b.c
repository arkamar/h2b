/* See LICENSE file for copyright and license details. */

#include <ctype.h>
#include <stdio.h>

static inline
char
hex2dec(const char c) {
	if ((unsigned)(c - '0') < 10)
		return c - '0';
	else /* if ((c | 0x20) - 'a' < 6) */ /* c | 0x20 -> to lower */
		return (c | 0x20) - 'a' + 10;
}

int
main(int argc, char * argv[]) {
	unsigned char c, o, i = 1;
	unsigned char iscomment = 0;

	while (fread(&c, 1, 1, stdin) > 0) {

		if (c == '#')
			iscomment = 1;

		if (iscomment && c == '\n')
			iscomment = 0;

		if (!iscomment && isxdigit(c)) {
			if (i % 2) {
				o = hex2dec(c) << 4;
			} else {
				o |= hex2dec(c);
				fwrite(&o, 1, 1, stdout);
			}
			i++;
		}
	}
	return 0;
}
