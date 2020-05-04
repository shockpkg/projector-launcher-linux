#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

const char errorGeneric[] = "Application not found.";
const char errorExecutable[] = "Application executable failed to run:";
const char dirext[] = ".data";
const size_t dirextL = sizeof(dirext) - 1;

size_t strLen(const char * str) {
	size_t i = 0;
	for (; str[i]; i++);
	return i;
}

char * strCpy(char * dest, const char * source, size_t len) {
	while (len--) {
		*(dest++) = *(source++);
	}
	*dest = '\0';
	return dest;
}

void memCpy(void * dest, void * src, size_t n) {
	char * s = (char *)src;
	char * d = (char *)dest;
	while (n--) {
		*(d++) = *(s++);
	}
}

inline char * strAlloc(size_t len) {
	return (char *)malloc(sizeof(char) * (len + 1));
}

inline char * getSelfPath() {
	return realpath("/proc/self/exe", NULL);
}

char * lastSlash(char * path) {
	char * slash = NULL;
	for (;; path++) {
		if (!*path) {
			return slash;
		}
		if (*path == '/') {
			slash = path;
		}
	}
}

char * resolveApplication() {
	// Get path to self or fail.
	char * self = getSelfPath();
	if (!self) {
		return NULL;
	}
	size_t selfL = strLen(self);

	// Get name from path or fail.
	char * name = lastSlash(self);
	if (!name) {
		free(self);
		return NULL;
	}
	name++;
	size_t nameL = strLen(name);

	// Create memory for the full path or fail.
	char * path = strAlloc(selfL + dirextL + 1 + nameL);
	if (!path) {
		free(self);
		return NULL;
	}

	// Assemble path.
	char * p = path;
	p = strCpy(p, self, selfL);
	p = strCpy(p, dirext, dirextL);
	*(p++) = '/';
	strCpy(p, name, nameL);

	free(self);
	return path;
}

int main(int argc, char ** argv) {
	// Resolve the path to the application to run.
	char * path = resolveApplication();
	if (!path) {
		// Output a generic error.
		fprintf(stderr, "%s\n", errorGeneric);
		return 1;
	}

	// Exec process or fail and continue past this.
	char ** args = (char **)malloc(sizeof(char *) * (argc + 1));
	if (args) {
		// Copy all the arguments, replacing first.
		memCpy(args, argv, sizeof(char *) * argc);
		args[0] = path;
		args[argc] = NULL;
		execv(path, args);
		free(args);
	}

	// Output error with the binary path.
	fprintf(stderr, "%s %s\n", errorExecutable, path);
	free(path);
	return 1;
}
