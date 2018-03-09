module Hotel
  class Block

    attr_reader :id, :check_in_date, :check_out_date, :discount, :rooms, :avail_room_count

    def initialize(block_hash)
      @id = block_hash[:id]
      @check_in_date = block_hash[:check_in_date]
      @check_out_date = block_hash[:check_out_date]
      @discount = block_hash[:discount]
      @rooms = block_hash[:rooms]
      @avail_room_count = @rooms.length
    end

  end
end
