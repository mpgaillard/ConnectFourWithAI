require_relative 'board'
require_relative 'computer_player'
require_relative 'human_player'



class Game
	attr_reader :player_turn, :players, :turn

	def initialize
		@board = Board.new
		@turn = rand(2)
		init_players	
		play
	end

	def init_players
		@players = [ HumanPlayer.new(@turn ? :red : :blue), ComputerPlayer.new(@turn ? :blue : :red) ]
	end

	def play
		#Recommended by ruby's author instead of a do while
		loop do
			puts @board
			player_move = @players[@turn].choose_column

			if @board.valid_column?(player_move)
				@board[player_move] = @players[@turn].insert_disc
				@turn = (@turn+1)%2
				break if game_over?(player_move)
			end
		end
		puts "Game Over!"
		puts @board
	end

	

	def game_over?(player_move)
		@board.next_available_row.max < 0 or @board.four_consecutive_discs(player_move)
	end

end

game = Game.new