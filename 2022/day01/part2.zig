const std = @import("std");
const io = std.io;
const test_input = @import("./test_input.zig");

fn insert_sorted(array: *[3]u32, x: u32) void {
	if (x >= array[1]) {
		if (x > array[0]) {
			array[2] = array[1];
			array[1] = array[0];
			array[0] = x;
		}
		else {
			array[2] = array[1];
			array[1] = x;
		}
	}
	else if (x > array[2]) {
		array[2] = x;
	}
}

fn process_stream(stream: *io.StreamSource) ![3]u32 {
	const reader = stream.reader();
	var buf: [11]u8 = undefined;
	var sum: u32 = 0;
	var best = [_]u32 { 0, 0, 0 };

	while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		if (line.len == 0) {
			insert_sorted(&best, sum);
			sum = 0;
			continue;
		}
		sum += try std.fmt.parseUnsigned(u32, line, 10);
	}
	insert_sorted(&best, sum);

	return best;
}

pub fn main() !void {
	const stdout = io.getStdOut().writer();

	const res = done: {
		var srm = io.StreamSource {
			.file = try std.fs.cwd().openFile("input.txt", .{ })
		};
		defer srm.file.close();

		const array = try process_stream(&srm);

		break :done array[0] + array[1] + array[2];
	};

	try stdout.print("{}\n", .{ res });
}

test "AoC" {
	var res = try process_stream(&test_input.stream);
	try std.testing.expect(res[0] == test_input.part2_value[0]);
	try std.testing.expect(res[1] == test_input.part2_value[1]);
	try std.testing.expect(res[2] == test_input.part2_value[2]);
}
