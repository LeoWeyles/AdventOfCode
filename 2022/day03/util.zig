const std = @import("std");
const StreamSource = std.io.StreamSource;

const ParseFnc = fn(StreamSource.Reader) anyerror!?u32;

pub const LINE_MAX = 2048;

pub const RuckSack = std.bit_set.StaticBitSet(52);

pub inline fn rucksack_bit(c: u8) u8
{
	return if (c >= 'a') c - 'a' else c - ('A' - 26);
}

fn process_stream(comptime parse: ParseFnc, stream: *std.io.StreamSource) !u32
{
	const reader = stream.reader();
	var sum: u32 = 0;

	while (try parse(reader)) |x|
		sum += x;

	return sum;
}

pub fn main(comptime parse: ParseFnc) !void
{
	const stdout = std.io.getStdOut().writer();

	const res = done: {
		var srm = StreamSource {
			.file = try std.fs.cwd().openFile("input.txt", .{ })
		};
		defer srm.file.close();

		break :done try process_stream(parse, &srm);
	};

	try stdout.print("{}\n", .{ res });
}

pub const test_input =
	\\vJrwpWtwJgWrhcsFMMfFFhFp
	\\jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
	\\PmmdzqPrVvPwwTWBwg
	\\wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
	\\ttgJtRGJQctTZtZT
	\\CrZsJsPPZsGzwwsLwLmpwMDw
	\\
	;

pub fn run_test(comptime part2: bool, comptime parse: ParseFnc) !void
{
	var stream = StreamSource {
		.const_buffer = std.io.fixedBufferStream(test_input)
	};

	const res = try process_stream(parse, &stream);
	const match: u32 = if (part2) 70 else 157;
	try std.testing.expect(res == match);
}
