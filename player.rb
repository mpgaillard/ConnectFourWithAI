require_relative 'disc'

class Player
	attr_reader :color, :name
	
	def initialize(name, color)
		@color = color
		@name = name
	end

	def insert_disc
		Disc.new(@color)
	end
	
end