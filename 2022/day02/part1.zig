const std = @import("std");
const io = std.io;
const test_input = @import("./test_input.zig");

const RESULT = [3][3]u8 {
	// rock  paper  scissors
	.{ 1+3,  1+0,   1+6 }, // rock
	.{ 2+6,  2+3,   2+0 }, // paper
	.{ 3+0,  3+6,   3+3 }, // scissors
};

fn process_stream(stream: *io.StreamSource) !u32
{
	const reader = stream.reader();
	var buf: [4]u8 = undefined;
	var sum: u32 = 0;

	while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		const oshape = line[0] - 'A';
		const pshape = line[2] - 'X';
		sum += RESULT[pshape][oshape];
	}

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
	const res = try process_stream(&test_input.stream);
	try std.testing.expect(res == test_input.part1_value);
}
