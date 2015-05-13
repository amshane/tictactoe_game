require 'pry'

class Board
	attr_accessor :boxes, :row_grid, :column_grid, :diagonals

	# initialize empty board
	def initialize
		@boxes = {
			1 => "-",
			2 => "-",
			3 => "-",
			4 => "-",
			5 => "-",
			6 => "-",
			7 => "-",
			8 => "-",
			9 => "-"
		}
	end

	# find grid box
	def get_box(x,y)
		row_grid[x][y]
	end

	# get row wins
	def row_grid
		[
			[ boxes[1], boxes[2], boxes[3] ],
			[ boxes[4], boxes[5], boxes[6] ],
			[ boxes[7], boxes[8], boxes[9] ]
		]
	end

	# get column wins
	def column_grid
		row_grid.transpose
	end

	# get diagonal wins
	def diagonals
		[ 
			[ get_box(0,0), get_box(1,1), get_box(2,2) ],
			[ get_box(0,2), get_box(1,1), get_box(2,0) ]
		]
	end

	# game introduction
	def introduce
		puts "Welcome to Tic Tac Toe!"
		puts " "
		puts "   1  |  2  |  3  "
		puts " -----+-----+-----"
		puts "   4  |  5  |  6  "
		puts " -----+-----+-----"
		puts "   7  |  8  |  9  "
		puts " "
	end

	# grid to show every turn
	def draw_grid
		puts "   #{boxes[1]}  |  #{boxes[2]}  |  #{boxes[3]}  "
		puts " -----+-----+-----"
		puts "   #{boxes[4]}  |  #{boxes[5]}  |  #{boxes[6]}  "
		puts " -----+-----+-----"
		puts "   #{boxes[7]}  |  #{boxes[8]}  |  #{boxes[9]}  "
		puts " "
	end

	# ask player if they want to go first
	def go_first?
		puts "Would you like to go first? (Y or N) "
		answer = gets.chomp.upcase
		if answer == "Y"
			true
		elsif answer == "N"
			false
		else
			puts "Invalid option. You did not enter Y or N. Please try again."
			go_first?
		end
	end
end


class Human
	attr_accessor :human_symbol

	def initialize(human_symbol)
		@human_symbol = human_symbol
	end

	# player's turn
	def turn(board)
		puts "Your turn. Enter a box number: "
		choice = gets.chomp.to_i
		if choice > 9 || choice < 1
			puts "You did not enter a number 1-9, Please try again."
			turn(board)
		elsif board.boxes[choice] != "-"
			puts "That move has already been taken, Please try again."
			turn(board)
		else
			board.boxes[choice] = @human_symbol
		end
	end
end


class Computer
	attr_accessor :comp_symbol

	def initialize(comp_symbol)
		@comp_symbol = comp_symbol
	end

	# find random open grid box for computer
	def random_choice(board)
		random = board.boxes.keys.sample until board.boxes[random] == "-"
		board.boxes[random] = @comp_symbol
	end

	# computer's turn
	def turn(board)
		puts "Computer's turn..."
		sleep(1)
		random_choice(board)
	end
end


class Game
	attr_accessor :human, :computer, :board

	# initialize new board and carry out play function
	def initialize
		@board = Board.new
		@human = human
		@computer = computer
		play
	end

	# player chooses if they want to be X or O
	def symbol_choice
		puts "Would you like to be X or O? "
		piece = gets.chomp.upcase
		if piece == "X"
			@human = Human.new("X")
			@computer = Computer.new("O")
		elsif piece == "O"
			@human = Human.new("O")
			@computer = Computer.new("X")
		else
			puts "Invalid option! You did not enter an X or an O. Please try again."
			symbol_choice
		end	
	end

	# check if all the grid boxes on the board are filled
	def all_filled?
		board.boxes.all? { |k, v| v != "-" }
	end

	# find wins
	def wins
		board.row_grid + board.column_grid + board.diagonals
	end

	# find the boxes that it takes for row wins, column wins, and diagonal wins. Iterate through those boxes to find the combination that gives you all X's or all O's in the whole line. Determine if the computer is the winner or the human based on their symbol.
	def check_for_winner
		wins.each do |line|
			if line.uniq == ["X"]
				if human.human_symbol == "X" 
					return "human"
				else
					return "computer"
				end
			elsif line.uniq == ["O"]
				if human.human_symbol == "O"
					return "human"
				else
					return "computer"
				end
			else
				nil
			end
		end
	end

  # check if the human won
  def human_winner?
  	check_for_winner == "human"
  end

  # check if the computer won
  def computer_winner?
  	check_for_winner == "computer"
  end

  # check if the game is over
  def game_over?
  	all_filled? || computer_winner? || human_winner?
  end

  # go human turn
  def human_turn
    unless game_over?
      human.turn(board)
      board.draw_grid
    end
  end
  
  # go computer turn
  def computer_turn
    unless game_over?
      computer.turn(board)
      board.draw_grid
    end
  end

  # play tictactoe
	def play
		symbol_choice
    if board.go_first?
    	board.introduce
    	while !game_over?
    		human_turn
    		computer_turn
    	end
    else
    	board.introduce
    	while !game_over?
    		computer_turn
    		human_turn
    	end
    end
    winner_announcement
  end

  # announce game over with winner or tie
  def winner_announcement
  	if computer_winner?
      puts "~ I'M SORRY! THE COMPUTER BEAT YOU... YOU LOST! ~"
      play_again?
    elsif human_winner?
      puts "~ CONGRATULATIONS! YOU WON!!! ~"
      play_again?
    else
      puts "~ CATS GAME... IT WAS A TIE! ~"
      play_again?
    end
  end

  # ask to play again
  def play_again?
		puts "Would you like to play again (Y or N) "
		answer = gets.chomp.upcase
		if answer == "Y"
			true
			new_game = Game.new
		elsif answer == "N"
			false
			puts "***** THANKS FOR PLAYING! GOODBYE! *****"
		else
			puts "Invalid option. You did not enter Y or N. Please try again."
			play_again?
		end
  end

end

game = Game.new
