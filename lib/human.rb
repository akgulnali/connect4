class Human < Player
	attr_accessor :name

	def initialize(name)
  	@name = name
	end

	def turn
  	gets.chomp.to_i
	end
end