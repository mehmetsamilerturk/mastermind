class Computer
  attr_reader :numbers, :same_numbers, :correct_position, :index_code, :index_guess

  def initialize
    @numbers = []
    @correct_position = []
    @index_code = {}
    @index_guess = {}
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

    @same_numbers = guess_split.select do |num_guess|
      code_split.include?(num_guess)
    end

    code_split.each_with_index do |num, index|
      @index_code[index] = num
      @index_code
    end

    guess_split.each_with_index do |num, index|
      @index_guess[index] = num
      @index_guess
    end

    @index_code.each do |key_code, value_code|
      @index_guess.each do |key_guess, value_guess|
        @correct_position.push(value_guess) if key_code == key_guess && value_code == value_guess
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
p computer.numbers

puts 'enter a number: '
human.guess_color
computer.compare(human)
p computer.same_numbers
p computer.correct_position
