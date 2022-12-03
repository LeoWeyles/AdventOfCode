const std = @import("std");
const io = std.io;
const test_input = @import("./test_input.zig");

const RESULT = [3][3]u8 {
	// 1=rock, 2=paper, 3=scissors
	// lose  tie    win
	.{ 0+3,  3+1,   6+2 }, // rock
	.{ 0+1,  3+2,   6+3 }, // paper
	.{ 0+2,  3+3,   6+1 }, // scissors
};

fn process_stream(stream: *io.StreamSource) !u32
{
	const reader = stream.reader();
	var buf: [4]u8 = undefined;
	var sum: u32 = 0;

	while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		const shape = line[0] - 'A';
		const cond = line[2] - 'X';
		sum += RESULT[shape][cond];
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
	try std.testing.expect(res == test_input.part2_value);
}
