require_relative "player"


class ComputerPlayer < Player

	def initialize(color)
		super(color)	
	end

	def get_input
		puts "Please choose a column to drop a piece(0-6):"
		gets.chomp
	end

	def choose_column
		get_input
	end


end