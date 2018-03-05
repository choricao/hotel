require_relative 'room'

module Hotel
  class Reservation

    attr_reader :check_in_date, :check_out_date, :room, :cost

    def initialize(check_in_date, check_out_date, room)
      if check_in_date >= check_out_date
        raise ArgumentError.new("Invalid check out date")
      end

      @check_in_date = check_in_date
      @check_out_date = check_out_date
      @room = room
      @cost = calculate_cost
    end

    private

    def calculate_cost
      return ((check_out_date - check_in_date) * @room.rate).to_i
    end

  end
end
