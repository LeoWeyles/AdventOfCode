const std = @import("std");
const util = @import("./util.zig");

fn parse_rucksack(line: []const u8) util.RuckSack
{
	var res = util.RuckSack.initEmpty();
	for (line) |c|
		res.set(util.rucksack_bit(c));
	return res;
}

fn parse(reader: std.io.StreamSource.Reader) !?u32
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

pub fn main() !void
{
	return util.main(parse);
}

test "AoC"
{
	return util.run_test(true, parse);
}
