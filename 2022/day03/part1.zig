const std = @import("std");
const io = std.io;
const util = @import("./util.zig");

fn find_priority(line: []const u8) u32
{
	const mid = line.len >> 1;
	var seen = util.RuckSack.initEmpty();

	// first compartment
	for (line[0 .. mid]) |c|
		seen.set(util.rucksack_bit(c));

	// second compartment
	for (line[mid .. line.len]) |c| {
		const bit = util.rucksack_bit(c);
		if (seen.isSet(bit))
			return bit+1;
	}

	return 0;
}

fn process_stream(stream: *io.StreamSource) !u32
{
	const reader = stream.reader();
	var buf: [util.LINE_MAX]u8 = undefined;
	var sum: u32 = 0;

	while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line|
		sum += find_priority(line);

	return sum;
}

pub fn main() !void
{
	const stdout = io.getStdOut().writer();

	const res = done: {
		var srm = io.StreamSource {
			.file = try std.fs.cwd().openFile("input.txt", .{ })
		};
		defer srm.file.close();

		break :done try process_stream(&srm);
	};

	try stdout.print("{}\n", .{ res });
}

test "AoC"
{
	const res = try process_stream(&util.test_input.stream);
	try std.testing.expect(res == util.test_input.part1_value);
}
