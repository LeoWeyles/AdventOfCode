const std = @import("std");
const io = std.io;
const test_input = @import("./test_input.zig");

fn process_stream(stream: *io.StreamSource) !u32
{
	const reader = stream.reader();
	var buf: [11]u8 = undefined;
	var sum: u32 = 0;
	var maxsum: u32 = 0;

	while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		if (line.len == 0) {
			maxsum = @max(maxsum, sum);
			sum = 0;
			continue;
		}
		sum += try std.fmt.parseUnsigned(u32, line, 10);
	}

	return @max(maxsum, sum);
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
