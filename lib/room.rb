module Hotel
  class Room

    attr_reader :number, :rate
    attr_accessor :status

    def initialize(number, rate)
      if !(1..20).include?(number)
        raise ArgumentError.new("Invalid room number")
      end
      @number = number
      @rate = rate
      @status = :AVAILABLE
    end

  end
end
