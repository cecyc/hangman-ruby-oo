require_relative "input"

class UserChoice
  ERROR_MESSAGE = "Invalid input, please try again."

  def initialize(message, &validator)
    @message = message
    @input = Input.new(&validator)
  end

  def get
    puts @message
    @input.value = gets.chomp

    while !@input.valid?
      puts Paint[ERROR_MESSAGE, :red]
      @input.value = gets.chomp
    end

    @input.value
  end
end
