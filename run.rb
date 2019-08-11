require './lib/game'
require './lib/player'
require './lib/human'
require './lib/computer'
require 'optparse'

@options = {
  computer: nil,
  num_players: 2,
  width: 7,
  height: 6
}
@errors = []

OptionParser.new do |opts|
  opts.on("-w NUM", "--width NUM", "Adjust board width", Integer) do |width|
    if width < 7
      @errors << "Width cannot be less than 7!"
    else
      @options[:width] = width
    end
  end
  opts.on("-h NUM", "--height NUM", "Adjust board height", Integer) do |height|
    if height < 6
      @errors << "Height cannot be less than 6!"
    else
      @options[:height] = height
    end
  end
  opts.on("-l NUM", "--length NUM", "Adjust streak length", Integer) do |length|
    max_streak = [@options[:height], @options[:width]].min
    if length < 4
      @errors << "Streak length cannot be less than 4!"
    elsif length > max_streak
      @errors << "Streak length cannot be greather than #{max_streak}"
    else
      @options[:length] = length
    end
  end
  opts.on("--strict", "Adjust strict streak length") do
    @options[:strict] = true
  end
  opts.on("--num-players NUM", "Adjust number of players", Integer) do |num_players|
    if num_players < 2
      @errors << "Number of players cannot be less than 2!"
    else
      @options[:num_players] = num_players
    end
  end
  opts.on("--computer a,b", "Allow computer players", Array) do |computer|
    if computer == ["1"] || computer == ["0","1"]
      @options[:computer] = computer
    else
      @errors << "Invalid pattern!"
    end
  end
  opts.on('--help', 'Display option list') do
    puts opts
    exit
  end
end.parse!()

if @errors.empty?
  puts "Selected Modes: #{@options}"
else
  @errors.each { |e| puts e }
  exit
end

def create_human_player(num_players)
  players = []
  (1..num_players).each do |i|
    players << Human.new("P#{i}")
  end
  return players
end

loop do
  puts "====================== Welcome To Connect 4 Extreme Game ======================"
  puts "Press enter to start a new game or press 'q' to quit."
  choice = STDIN.gets.chomp
  case choice
  when ""
    case @options[:computer]
    when ["1"]
      players = [Human.new("P1"), Computer.new("P2")]
    when ["0", "1"]
      players = [Computer.new("P1"), Computer.new("P2")]
    when nil
      players = create_human_player(@options[:num_players])
    end
    params = {
      players: players,
      row: @options[:width],
      col: @options[:height],
      length: @options[:length],
      strict: @options[:strict]
    }.compact 
    game = Game.new(params)
  when 'q'
    exit 0
  end
  game.play if game
end
