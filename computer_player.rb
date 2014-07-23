require_relative "player"
require_relative "ai_state"
#require 'debugger'

class ComputerPlayer < Player

	attr_accessor :opponent 
	INF = 1000000
	def initialize(name, color, opponent=nil)
		super(name, color)
		@opponent = opponent	
	end

	
	def negamin(board, move, depth, maximizing_player)
		#UNCOMMENT THIS IF YOU WANT TO SEE SOMETHING COOL
		#puts board
		if board.four_consecutive_discs(move)
			AIState.new(move, INF)
		elsif depth == 0
			AIState.new(move, board.heuristic_count(move))
		else
			generate_solution(board, move, depth, maximizing_player)
		end	
	end

	def generate_solution(board, move, depth, maximizing_player)
		alpha = AIState.new( board.first_valid_col, INF)
		(0...board.cols).each do |i|
			if board.valid_column?(i.to_s)

				board[i] = maximizing_player ? insert_disc : @opponent.insert_disc
				child = negamin(board, i, depth-1, !maximizing_player)
				if -child.score < alpha.score
					alpha.score = -child.score
					alpha.move = i
				end	
				board.take_back_move(i)
			end
		end
		alpha
	end


	def choose_column(board)
		generate_solution(board, -1, 6, true).move.to_s
		#get_input
	end

end