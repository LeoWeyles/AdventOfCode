const std = @import("std");
const io = std.io;

fn process_stream(stream: *io.StreamSource) !u32 {
	const reader = stream.reader();
	var buf: [11]u8 = undefined;
	var sum: u32 = 0;
	var maxsum: u32 = 0;

	while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		if (line.len == 0) {
			if (maxsum < sum)
				maxsum = sum;
			sum = 0;
			continue;
		}
		sum += try std.fmt.parseUnsigned(u32, line, 10);
	}

	return if (maxsum >= sum) maxsum else sum;
}

pub fn main() !void {
	const stdout = io.getStdOut().writer();

	const res = done: {
		var srm = io.StreamSource {
			.file = try std.fs.cwd().openFile("input.txt", .{ })
		};
		defer srm.file.close();
		break :done try process_stream(&srm);
	};

	try stdout.print("{}", .{ res });
}

test "AoC" {
	const test_data =
		\\1000
		\\2000
		\\3000
		\\
		\\4000
		\\
		\\5000
		\\6000
		\\
		\\7000
		\\8000
		\\9000
		\\
		\\10000
		;
	var srm = io.StreamSource {
		.const_buffer = io.fixedBufferStream(test_data)
	};

	const res = try process_stream(&srm);
	try std.testing.expect(res == 24000);
}
