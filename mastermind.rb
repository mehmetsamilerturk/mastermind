class Computer
  attr_reader :numbers, :same_numbers, :correct_position, :wrong_position, :code_remainder, :guess_remainder

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
p computer.numbers

puts 'enter a number: '
human.guess_color

computer.compare(human)

size_correct = computer.correct_position.size
size_wrong = computer.wrong_position.size

correct_cpy = computer.correct_position.dup
wrong_cpy = computer.wrong_position.dup

correct_cpy.replace(Array.new(size_correct, 'O'))
wrong_cpy.replace(Array.new(size_wrong, 'X'))

p computer.correct_position
p computer.wrong_position
p (correct_cpy + wrong_cpy).join
