class AIState
	attr_accessor :move, :score

	def initialize(move, score)
    	@move = move
    	@score = score
  	end
	def <=(b)
		return @move <= b.move
	end

end