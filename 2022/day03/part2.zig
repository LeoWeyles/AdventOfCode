const std = @import("std");
const mem = std.mem;
const io = std.io;
const util = @import("./util.zig");

fn parse_rucksack(line: []const u8) util.RuckSack
{
	var res = util.RuckSack.initEmpty();
	for (line) |c|
		res.set(util.rucksack_bit(c));
	return res;
}

fn parse_group(reader: io.StreamSource.Reader) !?u6
{
	var buf: [util.LINE_MAX]u8 = undefined;

	if (try reader.readUntilDelimiterOrEof(&buf, '\n')) |l| {
		var items = parse_rucksack(l);

		var line = try reader.readUntilDelimiter(&buf, '\n');
		items.setIntersection(parse_rucksack(line));

		line = try reader.readUntilDelimiter(&buf, '\n');
		items.setIntersection(parse_rucksack(line));

		if (items.findFirstSet()) |i|
			return @intCast(u6, i+1);
		return 0;
	}

	return null;
}

fn process_stream(stream: *io.StreamSource) !u32
{
	const reader = stream.reader();
	var sum: u32 = 0;

	while (try parse_group(reader)) |priority|
		sum += priority;

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
	try std.testing.expect(res == util.test_input.part2_value);
}
