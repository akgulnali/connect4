class Computer < Player
	attr_accessor :name

	def initialize(name)
  	@name = name
	end

	def turn
		row = self.game.instance_variable_get(:@row)
  	rand(1..row)
	end
end