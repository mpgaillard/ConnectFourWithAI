require_relative "player"
require_relative "ai_state"
#require 'debugger'

class ComputerPlayer < Player

	attr_reader :opponent 
	INF = 1000000
	def initialize(color, opponent)
		super(color)
		@opponent = opponent	
	end

	
	def minimax(board, move, depth)
		#UNCOMMENT THIS IF YOU WANT TO SEE SOMETHING COOL
		#puts board
		if board.next_available_row.max < 0
			AIState.new(move, 0)
		elsif board.four_consecutive_discs(move)
			AIState.new(move, INF)
		elsif depth == 0
			AIState.new(move, board.heuristic_count(move) )
		else
			generate_possible_moves(board, move, depth)
		end	
	end

	def generate_possible_moves(board, move, depth)
		alpha = AIState.new( board.first_valid_col, INF)
		(0...board.cols).each do |i|
			if board.valid_column?(i.to_s)
				board[i] = depth%2 == 0 ? insert_disc : @opponent.insert_disc
				child = minimax(board, i, depth-1)
				if -child.score < alpha.score
					alpha.score = -child.score
					alpha.move = i
				end	
				board.take_back_move(i)
			end
		end
		alpha
	end


	def get_input
		puts "Please choose a column to drop a piece(0-6):"
		gets.chomp
	end


	def choose_column(board)
		generate_possible_moves(board, -1, 6).move.to_s
		#get_input
	end

end