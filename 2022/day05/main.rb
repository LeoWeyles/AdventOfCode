def parse_stacks_line stacks, line
	i = 1
	while c = line[i]
		stacks[i >> 2].insert 0, c unless c == ?\s
		i += 4
	end
end

def parse_crates
	line = $stdin.readline()

	stacks = (line.size >> 2).times().map do
		[]
	end

	parse_stacks_line stacks, line

	$stdin.each_line do
		|line|
		break if line =~ /^ \d/
		parse_stacks_line stacks, line
	end

	stacks
end

def get_result stacks
	res = ''
	for s in stacks
		res << s[-1]
	end
	res
end

def main &move_crates
	# stage 1: the (ASCII) drawing
	stacks = parse_crates()

	# stage 2: the operations
	$stdin.each_line do
		|line|

		next unless line =~ /^move (\d+) from (\d+) to (\d+)$/
		n = $1.to_i()
		from = stacks[$2.to_i()-1]
		to = stacks[$3.to_i()-1]

		move_crates.(to, from, n)
	end

	puts get_result(stacks)
end
