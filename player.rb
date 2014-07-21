require_relative 'disc'

class Player
	attr_reader :color
	
	def initialize(color)
		@color = color
	end

	def insert_disc
		Disc.new(@color)
	end
	
end