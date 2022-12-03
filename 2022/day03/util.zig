const std = @import("std");

pub const LINE_MAX = 2048;

pub const RuckSack = std.bit_set.StaticBitSet(52);

pub inline fn rucksack_bit(c: u8) u8
{
	return if (c >= 'a') c - 'a' else c - ('A' - 26);
}

pub const test_input = struct {
	pub const data =
		\\vJrwpWtwJgWrhcsFMMfFFhFp
		\\jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
		\\PmmdzqPrVvPwwTWBwg
		\\wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
		\\ttgJtRGJQctTZtZT
		\\CrZsJsPPZsGzwwsLwLmpwMDw
		\\
		;

	pub var stream = std.io.StreamSource {
		.const_buffer = std.io.fixedBufferStream(data)
	};

	pub const part1_value: u32 = 157;
	pub const part2_value: u32 = 70;
};
