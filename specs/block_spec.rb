require_relative 'spec_helper'

describe "Block" do

  describe "initialize" do
    before do
      @id = 1
      @check_in_date = Date.new(2018, 3, 5)
      @check_out_date = Date.new(2018, 3, 7)
      @discount = 0.8
      @rooms = []
      (1..5).to_a.each do |num|
        @rooms << Hotel::Room.new(num, 200)
      end
      block_hash = {
        id: @id,
        check_in_date: @check_in_date,
        check_out_date: @check_out_date,
        discount: @discount,
        rooms: @rooms
      }
      @block = Hotel::Block.new(block_hash)
    end

    it "creates an instance of Block" do
      @block.must_be_instance_of Hotel::Block
    end

    it "accesses id of the block" do
      @block.must_respond_to :id
      @block.id.must_be_kind_of Integer
      @block.id.must_equal @id
    end

    it "accesses the check_in_date" do
      @block.must_respond_to :check_in_date
      @block.check_in_date.must_be_kind_of Date
      @block.check_in_date.must_equal @check_in_date
    end

    it "accesses the check_out_date" do
      @block.must_respond_to :check_out_date
      @block.check_out_date.must_be_kind_of Date
      @block.check_out_date.must_equal @check_out_date
    end

    it "accesses the discount rate for this block" do
      @block.must_respond_to :discount
      @block.discount.must_be_kind_of Float
      @block.discount.must_equal @discount
    end

    it "accesses a list of rooms stored in this block" do
      @block.must_respond_to :rooms
      @block.rooms.must_be_instance_of Array
      @block.rooms.length.must_equal 5
      @block.rooms.each do |room|
        room.must_be_instance_of Hotel::Room
      end
    end

    it "accesses number of available rooms in this block" do
      @block.must_respond_to :avail_room_count
      @block.avail_room_count.must_be_instance_of Integer
      @block.avail_room_count.must_equal 5
    end

  end

end
