#include <stdio.h>

int
main(int argc, char * argv[]) {
	unsigned char c;

	while (fread(&c, 1, 1, stdin) > 0)
		printf("%02x", c);

	return 0;
}
