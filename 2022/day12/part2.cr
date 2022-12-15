require "./common.cr"

class Part2 < Day12
	def solve()
		find_path_length(*@end) do|from, to|
			to.height == 'a' if to.valid_edge? from
		end
	end
end

part2 = Part2.new()
part2.parse(STDIN)
puts part2.solve()
