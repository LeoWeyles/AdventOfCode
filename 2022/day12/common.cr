require "deque"

class Day12
	class Vertex
		property height : Char
		property seen : Bool = false

		def initialize(@height)
		end

		def valid_edge?(dest : Vertex)
			@height+1 >= dest.height
		end
	end

	alias Row = Array(Vertex)

	def initialize()
		@start = @end = { 0i32, 0i32 }
		@matrix = [] of Row
	end

	def parse(line : String) : Nil
		row = Row.new(line.size)

		line.each_char_with_index do|c, i|
			if c == 'S'
				@start = { @matrix.size, i }
				c = 'a'
			elsif c == 'E'
				@end = { @matrix.size, i }
				c = 'z'
			end
			row.push Vertex.new(c)
		end

		@matrix.push row
	end

	def parse(io : IO)
		while line = STDIN.gets(chomp: true)
			parse line
		end
	end

	private def vertex_at(x : Int32, y : Int32) : Vertex?
		return nil unless x >= 0 && y >= 0
		row = @matrix[x]?
		row ? row[y]? : nil
	end

	private def walk_adjacent(row : Int32, col : Int32) : Nil
		(-1 .. +1).each do|i|
			(-1 .. +1).each do|j|
				next unless i & j == 0

				x = row+i
				y = col+j
				v = vertex_at(x, y)
				yield v, { x, y } if v
			end
		end
	end

	def find_path_length(xstart : Int32, ystart : Int32) : UInt32?
		from = @matrix[xstart][ystart]
		from.seen = true

		todo = Deque.new(1, { from, xstart, ystart, 0u32 })

		until todo.empty?
			from, x, y, dist = todo.shift()

			walk_adjacent x, y do|to, coord|
				next if to.seen

				found : Bool? = yield(from, to)
				next if found.nil?
				return dist+1 if found.as Bool

				todo << { to, *coord, dist+1 }

				to.seen = true
			end
		end

		nil
	end
end
