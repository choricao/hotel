module Hotel
  class FrontDesk

    attr_reader :rooms, :reservations, :room_blocks

    def initialize
      @rooms = generate_rooms
      @reservations = []
      @room_blocks = {}
    end

    def add_reservation(check_in_date, check_out_date)
      check_date(check_in_date)
      check_date(check_out_date)
      check_date_range(check_in_date, check_out_date)

      avail_rooms = get_avail_rooms(check_in_date, check_out_date)

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

    def get_avail_rooms(check_in_date, check_out_date)
      avail_rooms_array = []
      (check_in_date...check_out_date).to_a.each do |date|
        avail_rooms_array << list_empty_rooms(date)
      end

      avail_rooms = avail_rooms_array[0]
      (avail_rooms_array.length - 1).times do |i|
        avail_rooms = avail_rooms & avail_rooms_array[i + 1]
      end

      blocked_rooms = []
      @room_blocks.each do |block_id, block_value|
        if ((check_in_date...check_out_date).to_a & (block_value[:check_in_date]...block_value[:check_out_date]).to_a) != []
          get_avail_rooms_from_block(block_id).each do |room|
            blocked_rooms << room
          end
        end
      end

      return avail_rooms - blocked_rooms
    end

    def create_room_block(check_in_date, check_out_date, room_count, discount)
      check_date(check_in_date)
      check_date(check_out_date)
      check_date_range(check_in_date, check_out_date)
      check_room_count(room_count)

      avail_rooms = get_avail_rooms(check_in_date, check_out_date)

      if avail_rooms.length < room_count
        raise Exception.new("Not enough rooms for creating a room block")
      else
        rooms = []
        room_count.times do
          rooms << avail_rooms.pop
        end
        block_id = @room_blocks.length.to_s
        block_value = { rooms: rooms, check_in_date: check_in_date, check_out_date: check_out_date, discount: discount }

        @room_blocks[block_id] = block_value
        return block_value
      end
    end

    def reserve_from_block(block_id)
      rooms = get_avail_rooms_from_block(block_id)
      block_value = @room_blocks[block_id]

      check_in_date = block_value[:check_in_date]
      check_out_date = block_value[:check_out_date]
      reservation = Hotel::Reservation.new(check_in_date, check_out_date, rooms.pop)

      @reservations << reservation

      return reservation
    end

    def get_avail_rooms_from_block(block_id)
      block_value = @room_blocks[block_id]
      rooms = block_value[:rooms]
      if rooms.empty?
        raise Exception.new("No room available from this room block")
      else
        return rooms
      end
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

    def check_date_range(check_in_date, check_out_date)
      if check_in_date >= check_out_date
        raise ArgumentError.new("Invalid check out date")
      end
    end

    def check_room_count(room_count)
      if room_count.class != Integer || room_count <= 0 || room_count > 5
        raise ArgumentError.new("Invalid room count")
      end
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

  end
end
