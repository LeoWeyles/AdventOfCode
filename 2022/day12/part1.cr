require "./common.cr"

class Part1 < Day12
	def solve()
		x, y = @end
		goal = @matrix[x][y]

		find_path_length(*@start) do|from, to|
			to == goal if from.valid_edge? to
		end
	end
end

part1 = Part1.new()
part1.parse(STDIN)
puts part1.solve()
