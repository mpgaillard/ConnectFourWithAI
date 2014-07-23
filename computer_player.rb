require_relative "player"
require_relative "ai_state"
require 'debugger'

class ComputerPlayer < Player

	attr_accessor :opponent 
	INF = 1000000
	def initialize(name, color, opponent=nil)
		super(name, color)
		@opponent = opponent	
	end

	
	def minimax(board, move, depth, alpha, beta, maximizing_player)
		#UNCOMMENT THIS IF YOU WANT TO SEE SOMETHING COOL
		#puts board
		if board.four_consecutive_discs(move)
			AIState.new(move, maximizing_player ? INF : -INF)
		elsif depth == 0
			AIState.new(move, maximizing_player ? board.heuristic_count(move) : -board.heuristic_count(move))
		else
			generate_solution(board, move, depth, alpha, beta, !maximizing_player)
		end	
	end

	def generate_solution(board, move, depth, alpha, beta, maximizing_player)
		(0...board.cols).each do |i|
			if board.valid_column?(i.to_s)

				board[i] = maximizing_player ? insert_disc : @opponent.insert_disc
				child = minimax(board, i, depth-1, alpha.dup, beta.dup, maximizing_player)

				if maximizing_player
					if child.score > alpha.score
						alpha.score = child.score
						alpha.move = i
					end 
				else
					if child.score < beta.score
						beta.score = child.score
						beta.move = i
					end 
				end

				board.take_back_move(i)
				break if beta <= alpha

			end
		end
		return maximizing_player ? alpha : beta
	end


	def choose_column(board)
		generate_solution(board, -1, 6, AIState.new( board.first_valid_col, -INF), AIState.new( board.first_valid_col, INF), true).move.to_s
		#get_input
	end

end