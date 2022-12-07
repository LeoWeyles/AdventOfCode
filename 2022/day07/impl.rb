class Day07
	Dir = Struct.new(:children, :parent, :size)

	attr_reader :dirs, :root

	def initialize
		@dirs = []
		@dir = @root = create_dir(nil)
	end

	def parse
		sizeinc = 0
		skip = false

		$stdin.each_line do
			|line|
			case line
			when /^\$ cd (.+)/
				leave(sizeinc)
				enter $1
				skip = @dir.size != 0 # can't happen... right?
				sizeinc = 0
			when /^(\d+) /
				sizeinc += $1.to_i() if !skip && $1
			end
		end
		leave(sizeinc)
	end

private
	def create_dir parent
		d = Dir.new({ }, parent, 0)
		@dirs << d
		d
	end

	def subdir name
		@dir.children[name] ||= create_dir @dir
	end

	def enter name
		@dir = \
			case name
			when '/'
				@root
			when '..'
				@dir.parent
			else
				subdir name
			end
	end

	def leave addsize
		return unless addsize != 0
		dir = @dir
		dir.size += addsize
		while par = dir.parent
			par.size += addsize
			dir = par
		end
	end
end

def main &get_result
	parser = Day07.new()
	parser.parse()
	puts get_result.(parser)
end
