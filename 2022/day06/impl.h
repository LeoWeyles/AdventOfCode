#include <stdio.h>
#include <stdint.h>

typedef struct {
	size_t bufpos;
	uint32_t buf[DAY6_START_LEN-1];
} State;

static inline uint32_t to_flag(char c)
{
	return 1U << (c-'a');
}

static inline int is_start(State *s, char c)
{
	uint32_t seen = to_flag(c);
	for (int i = 0; i < DAY6_START_LEN-1; ++i) {
		uint32_t flag = s->buf[i];
		if (seen & flag)
			return 0;
		seen |= flag;
	}
	return 1;
}

static inline void update(State *s, char c)
{
	s->buf[s->bufpos] = to_flag(c);
	s->bufpos = (s->bufpos+1) % (DAY6_START_LEN-1);
}

static inline int valid_char(int c)
{
	return c >= 'a' && c <= 'z';
}

int main(void)
{
	size_t pos;
	State s;
	int c;

	s.bufpos = 0;

	for (pos = 1; pos < DAY6_START_LEN; ++pos) {
		if (!valid_char(c = getchar()))
			goto fail;
		update(&s, c);
	}

	while (1) {
		if (!valid_char(c = getchar()))
			goto fail;
		if (is_start(&s, c))
			break;
		update(&s, c);
		++pos;
	}

	printf("%zu\n", pos);

	return 0;

fail:
	return 1;
}
