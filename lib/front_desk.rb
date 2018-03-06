module Hotel
  class FrontDesk

    attr_reader :rooms, :reservations

    def initialize
      @rooms = generate_rooms
      @reservations = []
    end

    def add_reservation(check_in_date, check_out_date)
      # Your code should raise an exception when asked to reserve a room that is not available
      if check_in_date >= check_out_date
        raise ArgumentError.new("Invalid check out date")
      end
      
      avail_rooms_array = []
      (check_in_date...check_out_date).to_a.each do |date|
        avail_rooms_array << list_empty_rooms(date)
      end

      avail_rooms = avail_rooms_array[0]
      (avail_rooms_array.length - 1).times do |i|
        avail_rooms = avail_rooms & avail_rooms_array[i + 1]
      end

      if avail_rooms.empty?
        raise Exception.new("No room is available for this date range")
      else
        reservation = Hotel::Reservation.new(check_in_date, check_out_date, avail_rooms.sample)
        @reservations << reservation
        return reservation
      end
    end

    def list_reservations(date)
      check_date(date)

      list = []
      @reservations.each do |reservation|
        if reservation.check_in_date <= date && reservation.check_out_date > date
          list << reservation
        end
      end

      return list
    end

    def list_empty_rooms(date)
      check_date(date)

      reservation_list = list_reservations(date)
      reserved_rooms = []

      reservation_list.each do |reservation|
        reserved_rooms << reservation.room
      end

      return @rooms - reserved_rooms
    end

    private

    def generate_rooms
      rooms = []
      (1..20).to_a.each do |num|
        rooms << Hotel::Room.new(num, 200)
      end
      return rooms
    end

    def check_date(date)
      if date.class != Date
        raise ArgumentError.new("Invalid date")
      end
    end

  end
end
