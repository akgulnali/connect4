class Game
  def initialize(parameter={})
    @players = parameter.fetch(:players)
    @row = parameter.fetch(:row, 7)
    @col = parameter.fetch(:col, 6)
    @streak_length = parameter.fetch(:length, 4)
    @strict_mode = parameter.fetch(:strict, false)
    @space_length = (Math.log10([@row, @col].max).to_i+1) # Initialize cell length

    initialize_board(@row, @col) # Initialize board with row and col values
    initialize_teams(@players)
  end

  def initialize_board(row, col)
    @board = Array.new(row){Array.new(col).clear}
  end

  def initialize_players(player, disc_color)
  	player.game = self
  	player.disc_color = disc_color
  end

  def initialize_teams(players)
    @num_players = players.size
    @red_team = [] 
    @blue_team = []
    players.each do |player|
      player_num = player.name[/\d+/].to_i # gets number from player's name
      if player_num % 2 == 1
        initialize_players(player, "Red")
        @red_team << player
      elsif player_num % 2 == 0
        initialize_players(player, "Blue")
        @blue_team << player
      end
    end
  end

  def is_board_full?
    @board.join.length == @row * @col * @space_length
  end

  def is_pillar_full?(pillar)
    @board[pillar-1].length == @col
  end

  def print_board
    puts "-" * ((@space_length+1)*(@row+1))
    print " " * @space_length
    (1..@row).map { |num| print "|#{num.to_s.rjust(@space_length,'0')}" }
    puts "|\n"
    puts @board.each_with_index.map { |pillar, i| 
      pillar.dup.fill(" " * @space_length, pillar.length..@col-1)}
      .transpose
      .reverse
      .each_with_index
      .map{ |row,i| row.unshift((i+1).to_s.rjust(@space_length,'0')).join("|") }
      .join("|\n") + "|"
    puts "-" * ((@space_length+1)*(@row+1))
  end

  def winner(player)
    row = @pillar-1
    col = @board[@pillar-1].size-1
    disc_letter = get_disc_letter(player.disc_color) + " " * (@space_length-1)

    @shadow_board = Array.new(@row) { Array.new(@col) {0} } # Keeps records of visited cells.
    if @strict_mode
      return player.name if check_row(row, col, disc_letter) == @streak_length
    else 
      return player.name if check_row(row, col, disc_letter) >= @streak_length
    end

    @shadow_board = Array.new(@row) { Array.new(@col) {0} } # Clear previous results.
    if @strict_mode
      return player.name if check_col(row, col, disc_letter) == @streak_length
    else
      return player.name if check_col(row, col, disc_letter) >= @streak_length
    end
    
    @shadow_board = Array.new(@row) { Array.new(@col) {0} }
    if @strict_mode
      return player.name if check_minor_diagonal(row, col, disc_letter) == @steak_length
    else
      return player.name if check_minor_diagonal(row, col, disc_letter) >= @streak_length  
    end
    
    @shadow_board = Array.new(@row) { Array.new(@col) {0} }
    if @strict_mode
      return player.name if check_major_diagonal(row, col, disc_letter) == @steak_length
    else
      return player.name if check_major_diagonal(row, col, disc_letter) >= @streak_length
    end
  end

  def check_row(row, col, disc) # checks - direction
    if (row >= 0 && row < @row && @board[row][col] == disc && @shadow_board[row][col] == 0)
      @shadow_board[row][col] = 1
      return 1 + check_row(row+1, col, disc) + check_row(row-1, col, disc)
    else
      return 0
    end
  end

  def check_col(row, col, disc) # checks | direction
    if (col >= 0 && col < @col && @board[row][col] == disc && @shadow_board[row][col] == 0)
      @shadow_board[row][col] = 1
      return 1 + check_col(row,col+1,disc) + check_col(row,col-1,disc)
    else
      return 0
    end
  end

  def check_minor_diagonal(row, col, disc) # checks '/' diagonals.
    if (col >= 0 && col < @col && row >= 0 && row < @row && @board[row][col] == disc && @shadow_board[row][col] == 0)
      @shadow_board[row][col] = 1
      return 1 + check_minor_diagonal(row+1,col+1,disc) + check_minor_diagonal(row-1,col-1,disc)
    else
      return 0
    end
  end

  def check_major_diagonal(row, col, disc) # checks '\' diagonals.
    if (col >= 0 && col < @col && row >= 0 && row < @row && @board[row][col] == disc && @shadow_board[row][col] == 0)
      @shadow_board[row][col] = 1
      return 1 + check_major_diagonal(row+1,col-1,disc) + check_major_diagonal(row-1,col+1,disc)
    else
      return 0
    end
  end

  def insert_disc(pillar, disc_color)
    @board[pillar-1] << get_disc_letter(disc_color) + " " * (@space_length-1)
  end

  def get_disc_letter(disc_color)
    if disc_color == @red_team[0].disc_color
      return "x"
    elsif disc_color == @blue_team[0].disc_color
      return "o"
    end
  end

  def take_turn(player)
  	loop do
  		print "#{player.name}'s turn: "
      print "\n" if player.class == Computer
	  	@pillar = player.turn
	    if (1..@row).include?(@pillar) && !is_pillar_full?(@pillar)
	    	insert_disc(@pillar, player.disc_color)
	    	break
	    elsif !(1..@row).include?(@pillar)
	    	puts "Please enter a number from 1 to #{@row}!"
	    elsif is_pillar_full?(@pillar)
	    	puts "Pillar #{@pillar} is full!"
	    else
				puts "Invalid input!"
	    end
  	end
  end

  def play
    @red_counter = 0
    @blue_counter = 0
    current_player = nil
  	print_board
    loop do
      current_player = @red_team[@red_counter]
      take_turn(current_player)
      print_board
      @result = winner(current_player)
      @red_counter = (@red_counter + 1) % @red_team.length
      break if !@result.nil? || is_board_full?
      current_player = @blue_team[@blue_counter]
      take_turn(current_player)
      print_board
      @result = winner(current_player)
      @blue_counter = (@blue_counter + 1) % @blue_team.length
      break if !@result.nil? || is_board_full?
    end
    if !@result.nil?
      if @num_players > 2
        puts "The winner is team #{current_player.disc_color}"
      else
        puts "The winner is #{@result}!"
      end
    else
      puts "Draw!"
    end
  end
end
