const std = @import("std");
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

fn parse(reader: std.io.StreamSource.Reader) !?u32
{
	var buf: [util.LINE_MAX]u8 = undefined;
	if (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line|
		return find_priority(line);
	return null;
}

pub fn main() !void
{
	return util.main(parse);
}

test "AoC"
{
	return util.run_test(false, parse);
}
