require_relative 'room'

module Hotel
  class Reservation

    attr_reader :check_in_date, :check_out_date, :room, :discount
    attr_accessor :cost

    def initialize(check_in_date, check_out_date, room)
      if check_in_date >= check_out_date
        raise ArgumentError.new("Invalid check out date")
      end

      @check_in_date = check_in_date
      @check_out_date = check_out_date
      @room = room
      @discount = 1.0
      @cost = calculate_cost
    end

    def set_discount(discount)
      if discount >= 0 && discount <= 1
        @discount = discount
      else
        raise ArgumentError.new("Invalid discount rate.")
      end
    end

    private

    def calculate_cost
      return ((check_out_date - check_in_date) * @room.rate).to_i * @discount
    end

  end
end
