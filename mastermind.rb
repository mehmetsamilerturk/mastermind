module FormatOutput
  def format_output(player)
    player.guess.split('').map do |e|
      case e
      when '1'
        e = '1'.bg_blue
      when '2'
        e = '2'.bg_cyan
      when '3'
        e = '3'.bg_green
      when '4'
        e = '4'.bg_magenta
      when '5'
        e = '5'.bg_red
      when '6'
        e = '6'.bg_yellow
      end
    end
  end
end

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end

  def bg_red
    colorize(41)
  end

  def bg_green
    colorize(42)
  end

  def bg_blue
    colorize(44)
  end

  def bg_white
    colorize(47)
  end

  def bg_cyan
    colorize(46)
  end

  def bg_magenta
    colorize(45)
  end

  def bg_yellow
    colorize(43)
  end
end

class Computer
  include FormatOutput
  # Foreground digits are the ones that will never change, background digits are increasing.
  attr_reader :numbers, :correct_position, :wrong_position, :code_remainder, :guess_remainder
  attr_accessor :guess, :combinations

  def initialize
    @numbers = []
    @correct_position = []
    @wrong_position = []
    @guess = []
    @foreground_digits = []
  end

  def generate_code
    number = Random.new
    (1..4).each do |_i|
      @numbers.push(number.rand(1..6))
    end
    @numbers = @numbers.join
  end

  def compare(human)
    code_split = @numbers.split('')
    guess_split = human.guess.split('')

    code_split.each_with_index do |code_val, code_index|
      guess_split.each_with_index do |guess_val, guess_index|
        @correct_position.push(guess_val) if code_index == guess_index && code_val == guess_val
      end
    end

    @code_remainder = code_split.dup
    @guess_remainder = guess_split.dup

    @correct_position.all? do |n|
      idx = @code_remainder.index(n)

      return false if idx.nil?

      @code_remainder.delete_at(idx)
    end

    @correct_position.all? do |n|
      idx = @guess_remainder.index(n)

      return false if idx.nil?

      @guess_remainder.delete_at(idx)
    end

    @code_remainder.each do |code_val|
      @guess_remainder.each do |guess_val|
        next unless code_val == guess_val

        @wrong_position.push(guess_val)

        @guess_remainder.delete_at(@guess_remainder.index(guess_val))

        break
      end
    end
  end

  def guess_color
    a = [1, 2, 3, 4, 5, 6]
    b = [1, 2, 3, 4, 5, 6]
    c = [1, 2, 3, 4, 5, 6]
    d = [1, 2, 3, 4, 5, 6]
    @combinations = a.product(b, c, d)

    @guess = @combinations.sample.join
  end
end

class Human
  include FormatOutput

  attr_reader :guess, :secret_code, :correct_position, :wrong_position, :code_remainder, :guess_remainder

  def initialize
    @correct_position = []
    @wrong_position = []
  end

  def create_code
    @secret_code = gets.chomp
  end

  def guess_color
    @guess = gets.chomp
  end

  def compare(computer)
    code_split = @secret_code.split('')
    guess_split = computer.guess.split('')

    code_split.each_with_index do |code_val, code_index|
      guess_split.each_with_index do |guess_val, guess_index|
        @correct_position.push(guess_val) if code_index == guess_index && code_val == guess_val
      end
    end

    @code_remainder = code_split.dup
    @guess_remainder = guess_split.dup

    @correct_position.all? do |n|
      idx = @code_remainder.index(n)

      return false if idx.nil?

      @code_remainder.delete_at(idx)
    end

    @correct_position.all? do |n|
      idx = @guess_remainder.index(n)

      return false if idx.nil?

      @guess_remainder.delete_at(idx)
    end

    @code_remainder.each do |code_val|
      @guess_remainder.each do |guess_val|
        next unless code_val == guess_val

        @wrong_position.push(guess_val)

        @guess_remainder.delete_at(@guess_remainder.index(guess_val))

        break
      end
    end
  end
end

computer = Computer.new
human = Human.new

puts 'Would like to be the code maker or code breaker?'
puts "Enter '1' to be the code maker \nEnter '2' to be the code breaker"
choice = gets.chomp

if choice == '2'
  computer.generate_code

  puts "colors: #{'1'.bg_blue} #{'2'.bg_cyan} #{'3'.bg_green} #{'4'.bg_magenta} #{'5'.bg_red} #{'6'.bg_yellow}"

  i = 1

  until human.guess == computer.numbers

    puts 'enter a 4 digit number between 1-6: '
    human.guess_color

    computer.compare(human)

    size_correct = computer.correct_position.size
    size_wrong = computer.wrong_position.size

    correct_cpy = computer.correct_position.dup
    wrong_cpy = computer.wrong_position.dup

    correct_cpy.replace(Array.new(size_correct, 'O'.green))
    wrong_cpy.replace(Array.new(size_wrong, 'O'.red))

    puts "Turn #{i}"
    puts "#{human.format_output(human).join(' ')}  Clues: #{(correct_cpy + wrong_cpy).join}"
    i += 1

    computer.correct_position.clear
    computer.wrong_position.clear

  end
elsif choice == '1'
  puts "colors: #{'1'.bg_blue} #{'2'.bg_cyan} #{'3'.bg_green} #{'4'.bg_magenta} #{'5'.bg_red} #{'6'.bg_yellow}"
  print 'Enter your 4 digit secret code between these colors(1-6)> '
  human.create_code

  i = 1

  until computer.guess == human.secret_code

    computer.guess_color
    human.compare(computer)
    computer.combinations.delete(computer.guess)

    size_correct = human.correct_position.size
    size_wrong = human.wrong_position.size

    correct_cpy = human.correct_position.dup
    wrong_cpy = human.wrong_position.dup

    correct_cpy.replace(Array.new(size_correct, 'O'.green))
    wrong_cpy.replace(Array.new(size_wrong, 'O'.red))

    puts "Turn #{i}"
    i += 1
    puts "#{computer.format_output(computer).join(' ')}  Clues: #{(correct_cpy + wrong_cpy).join}"

    human.correct_position.clear
    human.wrong_position.clear
  end
else
  puts 'Invalid input'
end
