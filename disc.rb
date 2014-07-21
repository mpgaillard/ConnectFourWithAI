# encoding: utf-8
require 'colorize'

class Disc
	attr_accessor :color, :player

	def initialize(color)
		@color = color
	end
	
	def to_s
		@color == :none ? " " : "◉".colorize(@color)
	end

end