class Part2
	class Knot
		property x : Int32 = 0
		property y : Int32 = 0
	end

	def initialize(rope_len : UInt32)
		@head = Knot.new()

		@tail = [] of Knot
		(rope_len-1).times do
			@tail << Knot.new()
		end

		@seen = Set { { 0i32, 0i32 } }
	end

	getter seen

	private def add_pos
		tail = @tail[-1]
		@seen.add({ tail.x, tail.y })
	end

	macro move_tail(a, b)
		tail.{{a}} += {{a}}delta >> 1
		tail.{{b}} += {{b}}delta >> 1 | 1 if {{b}}delta != 0
	end

	private def move(xinc : Int32, yinc : Int32)
		head = @head
		head.x += xinc
		head.y += yinc

		@tail.each do|tail|
			xdelta = head.x - tail.x
			ydelta = head.y - tail.y

			if xdelta.abs > 1
				move_tail x, y
			elsif ydelta.abs > 1
				move_tail y, x
			else
				return
			end

			head = tail
		end

		add_pos()
	end

	def parse(line : String)
		direction = line[0]
		n = line[2 .. -1].to_i()

		n.times do
			case direction
			when 'R' then move +1, +0
			when 'L' then move -1, +0
			when 'D' then move +0, +1
			when 'U' then move +0, -1
			end
		end
	end
end

parser = Part2.new(10)
STDIN.each_line &->parser.parse(String)
puts parser.seen.size
