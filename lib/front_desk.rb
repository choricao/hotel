module Hotel
  class FrontDesk

    attr_reader :rooms, :reservations

    def initialize
      @rooms = generate_rooms
      @reservations = []
    end

    def add_reservation(check_in_date, check_out_date)
      room = @rooms.sample

      reservation = Hotel::Reservation.new(check_in_date, check_out_date, room)
      @reservations << reservation

      return reservation
    end

    def list_reservations(date)
      if date.class != Date
        raise ArgumentError.new("Invalid date")
      end

      list = []
      @reservations.each do |reservation|
        if reservation.check_in_date <= date && reservation.check_out_date > date
          list << reservation
        end
      end

      return list
    end

    private

    def generate_rooms
      rooms = []
      (1..20).to_a.each do |num|
        rooms << Hotel::Room.new(num, 200)
      end
      return rooms
    end

  end
end
