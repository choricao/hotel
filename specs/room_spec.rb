require_relative 'spec_helper'

xdescribe "Room" do

  describe "initialize" do
    before do
      @room = Hotel::Room.new(1, 200)
    end

    it "creates an instance of Room" do
      @room.must_be_instance_of Hotel::Room
    end

    it "accesses the room number" do
      @room.must_respond_to :number
      @room.number.must_be_kind_of Integer
      @room.number.must_equal 1
    end

    it "accesses the rate of the room" do
      @room.must_respond_to :rate
      @room.rate.must_be_instance_of Integer
      @room.rate.must_equal 200
    end

    it "raises an ArgumentError if the room number is invalid" do
      proc { Hotel::Room.new(21, 200) }.must_raise ArgumentError
    end

  end

end
