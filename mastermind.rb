class Computer
  attr_reader :numbers, :same_numbers
  def initialize
    @numbers = []
    @same_numbers = []
  end
  def generate_code
    number = Random.new
    for i in (1..4)
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

puts "enter a number: "
human.guess_color
computer.compare(human)
p computer.same_numbers.flatten.compact

