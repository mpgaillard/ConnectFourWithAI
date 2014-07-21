require_relative "player"
require_relative "ai_state"
require 'debugger'



class ComputerPlayer < Player

	attr_reader :opponent 

	def initialize(color, opponent)
		super(color)
		@opponent = opponent	
	end

	def min_move(a, b)

    	a < b ? a : b
   	end

	def alpha_beta(board, depth, lastMove, alpha, beta, maximizing)
		#puts board
		#debugger
		if board.next_available_row.max < 0 or depth == 0
			return AIState.new(lastMove, 0)
		elsif lastMove >= 0 and board.four_consecutive_discs(lastMove)
			return AIState.new(lastMove, maximizing ? 2 : 1)
		end 

		if maximizing
			(0...board.cols).each do |i|
				if board.valid_column?(i.to_s)
					board[i] = insert_disc
					child = alpha_beta(board, depth-1, i, alpha, beta, false)
					if child.score > alpha.score
						alpha.score = child.score
						alpha.move = i
					end
					board.take_back_move(i)
					break if beta <= alpha
				end
			end
			return alpha
		else
			(0...board.cols).each do |i|
				if board.valid_column?(i.to_s)
					board[i] = @opponent.insert_disc
					child = alpha_beta(board, depth-1, i, alpha, beta, false)
					if child.score < beta.score
						beta.score = child.score
						beta.move = i
					end
					#beta = [beta, alpha_beta(board, depth-1, i, alpha, beta, true) ].min
					board.take_back_move(i)
					break if beta <= alpha
				end
			end
			return beta
		end
	end

	def choose_column(board)
		res = alpha_beta(board, 7, -1, AIState.new(0, -1), AIState.new(0 ,1), true).move.to_s
		puts res 
		if board.valid_column?(res.to_s)
			res
		else
			(0...board.cols).each do |i|
				return i.to_s if board.valid_column?(i.to_s)
			end
		end
	end


end