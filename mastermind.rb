class Computer
  attr_reader :numbers, :same_numbers, :correct_position, :index_code, :index_guess, :wrong_position

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
        if key_code == key_guess && value_code == value_guess
          @correct_position.push(value_guess)
        end
      end
    end
  end
  # If ary2(correct numbers) is included in ary1(matched numbers), delete the values of ary2 found in ary1.
  # Assigns correct numbers with wrong positions to @wrong_position. Respects duplicates.
  def return_wrong(ary1, ary2)
    ary1_cpy = ary1.dup
    ary2.all? do |n|
      idx = ary1_cpy.index(n)
      return false if idx.nil?
      ary1_cpy.delete_at(idx)
    end
    @wrong_position = ary1_cpy
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
computer.return_wrong(computer.same_numbers, computer.correct_position)
p computer.same_numbers
p computer.correct_position
p computer.wrong_position