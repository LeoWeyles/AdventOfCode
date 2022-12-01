const io = @import("std").io;

pub const data =
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

pub var stream = io.StreamSource {
	.const_buffer = io.fixedBufferStream(data)
};

pub const part1_value: u32 = 24000;
pub const part2_value = [_]u32 { 24000, 11000, 10000 };
