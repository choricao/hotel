module Hotel
  class Room

    attr_reader :number, :rate

    def initialize(number, rate)
      if !(1..20).include?(number)
        raise ArgumentError.new("Invalid room number")
      end
      @number = number
      @rate = rate
    end

  end
end
