const io = @import("std").io;

pub const data =
	\\A Y
	\\B X
	\\C Z
	;

pub var stream = io.StreamSource {
	.const_buffer = io.fixedBufferStream(data)
};

pub const part1_value: u32 = 15;
pub const part2_value: u32 = 12;
