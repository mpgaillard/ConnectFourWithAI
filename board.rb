#require_relative 'disc'


class Board

	attr_accessor :grid, :disc
	attr_reader :rows, :cols, :next_available_row

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

	def count_discs(x, y, dir_x, dir_y, color)
		if (outside_of_boundaries?(x, y) or @grid[y][x] == " " or @grid[y][x].color != color)
			0
		else
			1 + count_discs(x+dir_x, y+dir_y, dir_x, dir_y, color)
		end
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
				return true if propagate_left + propagate_right - 1 == 4
			end
		end

		false
	end

end


