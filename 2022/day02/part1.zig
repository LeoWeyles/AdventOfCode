const impl = @import("./impl.zig");

const RESULT = [3][3]u8 {
	// 1=rock, 2=paper, 3=scissors
	// rock  paper  scissors
	.{ 1+3,  2+6,   3+0 }, // rock
	.{ 1+0,  2+3,   3+6 }, // paper
	.{ 1+6,  2+0,   3+3 }, // scissors
};

pub fn main() !void
{
	return impl.main(&RESULT);
}

test "AoC"
{
	return impl.run_test(false, &RESULT);
}
