#require_relative 'disc'


class Board

	attr_accessor :grid, :disc
	attr_reader :rows, :cols, :next_available_row
	INF = 10000
	def initialize(rows=6, cols=7)
		@rows, @cols = rows, cols
		@grid = Array.new(rows) {  |e| e = Array.new(cols, ' ' )  } 
		@next_available_row = Array.new(cols, rows-1)
	end

	def column_maxed(col)
		return @next_available_row[col] == 0
	end
	def to_s
		out = ""
		@rows.times  do |row|
			@cols.times do |col|
				out << "|".colorize(:light_yellow) << "#{grid[row][col]}"
			end
			out << "|\n".colorize(:light_yellow)
		end
		out << " " << (0..6).to_a.join(" ").colorize(:cyan) << "\n"
		out
	end

	def valid_column?(move)
		if move =~ /^[0-6]$/ and next_available_row[move.to_i] >= 0
			true
		else
			false
		end
	end

	def make_move(move, disc)
		move = move.to_i
		@grid[ @next_available_row[move] ][ move ] = disc
		@next_available_row[ move ] -= 1
	end

	def take_back_move(move)
		move = move.to_i
		if @next_available_row[move] < @rows-1
			@next_available_row[move] += 1
			@grid[ @next_available_row[move] ][ move ] = " "
		end
	end

	def []=(move, disc)
		make_move(move, disc)
	end

	def outside_of_boundaries?(x, y)
		y >= @rows or y < 0 or x >= @cols or x < 0
	end

	def heuristics_count_discs(x, y, dir_x, dir_y, depth, color)
		if(outside_of_boundaries?(x, y) or (@grid[y][x].is_a? Disc and @grid[y][x].color != color))
			-INF
		elsif depth == 0
			0
		else
			(@grid[y][x] == " " ? 0 : 1) + heuristics_count_discs(x+dir_x, y+dir_y, dir_x, dir_y, depth-1, color) 
		end
	end

	def heuristic_count(last_move)
		prc = Proc.new { |val| val <= 0 ? 0 : (val == 1 ? 1 : (val == 2 ? 4 : 42) )  }
		x = last_move.to_i
		y = @next_available_row[x] + 1 # previous row		
		color = @grid[y][x].color

		heuristic_val = 0

		(x-3...x).each do |start|
			val = heuristics_count_discs(start, y, 1, 0, 4, color)
			heuristic_val += prc.call(val)
		end

		(y-3...y).each do |start|
			val = heuristics_count_discs(x, start, 0, 1, 4, color)
			heuristic_val += prc.call(val)
		end


		(-3...0).each do |start|
			val = heuristics_count_discs(x+start, y+start, 1, 1, 4, color)
			heuristic_val += prc.call(val)
		end

		(-3...0).each do |start|
			val = heuristics_count_discs(x-start, y+start, -1, 1, 4, color)
			heuristic_val += prc.call(val)
		end

		heuristic_val
	end

	def count_discs(x, y, dir_x, dir_y, color)
		if (outside_of_boundaries?(x, y) or @grid[y][x] == " " or @grid[y][x].color != color)
			0
		else
			1 + count_discs(x+dir_x, y+dir_y, dir_x, dir_y, color)
		end
	end
	def count_discs_color_blind(x, y, dir_x, dir_y, color)
		if (outside_of_boundaries?(x, y) or @grid[y][x] == " ")
			0
		else
			1 + count_discs_color_blind(x+dir_x, y+dir_y, dir_x, dir_y, color)
		end
	end
	def four_consecutive_blind_discs(last_move)
		column = last_move.to_i
		row = @next_available_row[column] + 1 # previous row		
		color = @grid[row][column].color

		(-1..1).each do |dir_x|
			(0..1).each do |dir_y|
				next if dir_x == 0 and dir_y == 0
				propagate_left = count_discs_color_blind(column, row, dir_x, dir_y, color)
				propagate_right = count_discs_color_blind(column, row, -dir_x, -dir_y, color)
				return true if propagate_left + propagate_right - 1 >= 4
			end
		end
		false
	end

	def four_consecutive_discs(last_move)
		column = last_move.to_i
		row = @next_available_row[column] + 1 # previous row		
		color = @grid[row][column].color

		(-1..1).each do |dir_x|
			(0..1).each do |dir_y|
				next if dir_x == 0 and dir_y == 0
				propagate_left = count_discs(column, row, dir_x, dir_y, color)
				propagate_right = count_discs(column, row, -dir_x, -dir_y, color)
				propagate_left + propagate_right - 1 == 4
			end
		end
		false
	end

	def first_valid_col
		(0...@cols).each do |i|
				return i if valid_column?(i.to_s)
		end
	end

end


