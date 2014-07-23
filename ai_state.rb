class AIState
	attr_accessor :move, :score

	def initialize(move, score)
    	@move = move
    	@score = score
  	end
	def <=(b)
		return @score <= b.score
	end

end