require_relative './../models/flashcard.rb'

class Controller
  COMMANDS = {
    '1' => 'create_flashcard',
    '2' => 'play',
    '3' => 'exit'
  }

  def initialize
    @flashcards = Flashcard.load
  end

  def run
    loop do
      clear_screen
      menu
    end
  end

  def prompt(message, options={})
    puts message

    options[:multiline] ? multiline_response : gets.chomp
  end

  def multiline_response
    response = []

    until (line = gets.chomp).empty?
      response << line
    end

    response.join("\n")
  end

  def welcome
    puts "FLASHCARDS\n\n"
  end

  def menu
    welcome
    COMMANDS.each do |number, command|
      puts "\t#{number}. #{command.gsub('_', ' ')}"
    end

    handle_command
  end

  def handle_command
    number  = prompt "\nEnter command number:"
    command = COMMANDS[number]

    clear_screen && send(command) if command
  end

  def create_flashcard
    question = prompt 'Enter question:', multiline: true
    answer   = prompt 'Enter answer:'

    Flashcard.create(question: question, answer: answer)
  end

  def play
    @flashcards = Flashcard.load

    loop do
      clear_screen
      flip_card
      guess
    end
  end

  def flip_card
    @current_card = @flashcards.sample

    puts "#{@current_card.question}"
  end

  def guess
    case prompt 'Enter an answer, or type "exit":'
    when 'exit' then exit
    when @current_card.answer then correct
    else
      incorrect
    end
  end

  def correct
    clear_screen
    puts 'CORRECT!!!'
    sleep 1
  end

  def incorrect
    display 'ANSWER:'
    display @current_card.answer
    sleep 5
  end

  def display(message)
    puts "\n#{message}"
  end

  def clear_screen
    60.times do
      puts
    end
  end

  def exit
    abort
  end
end
