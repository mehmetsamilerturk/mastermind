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
  attr_reader :numbers, :correct_position, :wrong_position, :code_remainder, :guess_remainder

  def initialize
    @numbers = []
    @correct_position = []
    @wrong_position = []
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
        if code_val == guess_val
          @wrong_position.push(guess_val)

          @guess_remainder.delete_at(@guess_remainder.index(guess_val))

          break
        end
      end
    end
  end
end

class Human
  attr_reader :guess

  def guess_color
    @guess = gets.chomp
  end
end

computer = Computer.new
human = Human.new

computer.generate_code

puts "colors: #{'1'.bg_blue} #{'2'.bg_cyan} #{'3'.bg_green} #{'4'.bg_magenta} #{'5'.bg_red} #{'6'.bg_yellow}"

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

  formatted_outout = human.guess.split('').map do |e|
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

  puts "#{formatted_outout.join(' ')}  Clues: #{(correct_cpy + wrong_cpy).join}"
  computer.correct_position.clear
  computer.wrong_position.clear
end
