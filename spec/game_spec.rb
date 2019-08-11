require 'spec_helper'
require 'game'
require 'player'
require 'human'
require 'computer'

def create_new_game(players, row, col, length=nil, strict=nil)
	params = {
		players: players,
		row: row,
		col: col,
		length: length,
		strict: strict
	}.compact
	Game.new(params)
end

def create_human_player(name, disc_color)
	player = Human.new(name)
	player.disc_color = disc_color
	return player
end

def create_computer_player(name, disc_color)
	player = Computer.new(name)
	player.disc_color = disc_color
	return player
end

def populate_board(game, row, col)
	game.instance_variable_set(:@board, Array.new( row ){Array.new( col ) { 'x' } })
end

RSpec.describe Game, "#board" do
	before :each do
		@p1 = create_human_player("P1", "Red")
		@p2 = create_human_player("P2", "Blue")
		@game = create_new_game([@p1,@p2],7,6)
	end

	context "with some fleaks" do
		it "checks board is full" do
			populate_board(@game,7,6)
			expect(@game.is_board_full?).to eq true
		end

		it "checks board is not full" do
			expect(@game.is_board_full?).to eq false
		end

		it "checks pillar 1 is full" do
			populate_board(@game,7,6)
			expect(@game.is_pillar_full?(1)).to eq true
		end

		it "checks pillar 1 is not full" do
			expect(@game.is_pillar_full?(1)).to eq false
		end
	end

	it "insert Red disk to the pilar 1" do
		expect(@game.insert_disc(1, "Red")).to eq ["x"]
	end

	it "insert Blue disk to the pilar 1" do
		expect(@game.insert_disc(1, "Blue")).to eq ["o"]
	end

	it "should create custom board with row = 10 col = 10" do
		game = create_new_game([@p1,@p2],10,10)
		populate_board(game,10,10)
		board = game.instance_variable_get(:@board)
		expect(board.join.length).to eq 100
	end

	context "winner" do
		it "P1 wins with row straight" do
			@game.instance_variable_set(:@board, [['x'],['x'],['x'],['x'],[],[],[]])
			@game.instance_variable_set(:@pillar, 1)
			expect(@game.winner(@p1)).to eq "P1"
		end

		it "P1 wins with column straight" do
			@game.instance_variable_set(:@board, [['x','x','x','x'],[],[],[],[],[],[]])
			@game.instance_variable_set(:@pillar, 1)
			expect(@game.winner(@p1)).to eq "P1"
		end

		it "P1 wins with minor diagonal" do # /
			@game.instance_variable_set(:@board, [['x'],['o','x'],['x','o','x'],['o','x','o','x'],[],[],[]])
			@game.instance_variable_set(:@pillar, 1)
			expect(@game.winner(@p1)).to eq "P1"
		end

		it "P2 wins with major diagonal" do # \
			@game.instance_variable_set(:@board, [['x','o','x','o'],['o','x','o'],['x','o'],['o'],[],[],[]])
			@game.instance_variable_set(:@pillar, 1)
			expect(@game.winner(@p2)).to eq "P2"
		end

		it "P2 wins with streak length = 5" do
			@game.instance_variable_set(:@board, [['o'],['o'],['o'],['o'],['o'],[],[],[]])
			@game.instance_variable_set(:@pillar, 1)
			@game.instance_variable_set(:@streak_length, 5)
			expect(@game.winner(@p2)).to eq "P2"
		end

		it "P2 cannot win with streak length > 5 when streak length = 5" do 
			@game.instance_variable_set(:@board, [['o'],['o'],['o'],['o'],['o'],['o'],[],[]])
			@game.instance_variable_set(:@pillar, 3)
			@game.instance_variable_set(:@streak_length, 5)
			@game.instance_variable_set(:@strict_mode, true)
			expect(@game.winner(@p2)).to eq nil
		end

		it "Red team wins with player number = 3" do
			p3 = create_human_player("P3", "Red")
			game = create_new_game([@p1,@p2,p3],7,6)
			game.instance_variable_set(:@board, [['x'],['x'],['x'],['x'],[],[],[]])
			game.instance_variable_set(:@pillar, 1)
			expect(game.winner(p3)).to eq "P3"
		end

		it "Computer wins against human" do
			p2 = create_computer_player("P2", "Blue")
			game = create_new_game([@p1,p2],7,6)
			game.instance_variable_set(:@board, [['o'],['o'],['o'],['o'],[],[],[]])
			game.instance_variable_set(:@pillar, 1)
			expect(game.winner(p2)).to eq "P2"
		end
	end
end










