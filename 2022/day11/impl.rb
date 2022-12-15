class Day11
	Monkey =
		Struct.new(:active, :items, :opmult, :opval, :test, :ttest, :ftest)

	attr_reader :monkeys

	def initialize
		@monkeys = []
	end

	def parse line
		case line
		when /^Monkey (\d+):/
			@monkey = Monkey.new(0)
			@monkeys[$1.to_i()] = @monkey
		when /Starting items: (.+)/
			@monkey.items = $1.split(/\s*,\s*/).map do|i|
				i.to_i()
			end
		when /Operation: new = old (?:(\+)|\*) (?:(\d+)|old)/
			@monkey.opmult = !$1
			@monkey.opval = $2 ? $2.to_i() : nil
		when /Test: divisible by (\d+)/
			@monkey.test = $1.to_i()
		when /If true: throw to monkey (\d+)/
			@monkey.ttest = $1.to_i()
		when /If false: throw to monkey (\d+)/
			@monkey.ftest = $1.to_i()
		end
	end

	def round monkey
		for item in monkey.items
			opval = monkey.opval || item
			if monkey.opmult
				item *= opval
			else
				item += opval
			end

			item = worry_level(item)

			if item % monkey.test == 0
				@monkeys[monkey.ttest].items.push item
			else
				@monkeys[monkey.ftest].items.push item
			end

			monkey.active += 1
		end
		monkey.items.clear()
	end

	def run(rounds)
		rounds.times do
			for monkey in @monkeys
				round monkey
			end
		end

		first, second = @monkeys.max 2 do
			|x, y|
			x.active <=> y.active
		end

		first.active * second.active
	end
end
