const std = @import("std");
const io = std.io;

fn process_stream(stream: *io.StreamSource, restab: *const[3][3]u8) !u32
{
	const reader = stream.reader();
	var buf: [4]u8 = undefined;
	var sum: u32 = 0;

	while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		const first = line[0] - 'A';
		const second = line[2] - 'X';
		sum += restab[first][second];
	}

	return sum;
}

pub fn main(restab: *const [3][3]u8) !void
{
	const stdout = io.getStdOut().writer();

	const res = done: {
		var srm = io.StreamSource {
			.file = try std.fs.cwd().openFile("input.txt", .{ })
		};
		defer srm.file.close();

		break :done try process_stream(&srm, restab);
	};

	try stdout.print("{}\n", .{ res });
}

const test_input =
	\\A Y
	\\B X
	\\C Z
	;

pub fn run_test(comptime part2: bool, restab: *const [3][3]u8) !void
{
	var stream = io.StreamSource {
		.const_buffer = io.fixedBufferStream(test_input)
	};

	const res = try process_stream(&stream, restab);
	const match = if (part2) 12 else 15;
	try std.testing.expect(res == match);
}
