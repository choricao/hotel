require_relative 'spec_helper'

describe "Reservation" do

  describe "initialize" do
    before do
      @check_in_date = Date.new(2018, 3, 5)
      @check_out_date = Date.new(2018, 3, 7)
      @room = Hotel::Room.new(1, 200)
      @reservation = Hotel::Reservation.new(@check_in_date, @check_out_date, @room)
    end

    it "creates an instance of Reservation" do
      @reservation.must_be_instance_of Hotel::Reservation
    end

    it "accesses the check in date" do
      @reservation.must_respond_to :check_in_date
      @reservation.check_in_date.must_be_kind_of Date
      @reservation.check_in_date.must_equal @check_in_date
    end

    it "accesses the check out date" do
      @reservation.must_respond_to :check_out_date
      @reservation.check_out_date.must_be_instance_of Date
      @reservation.check_out_date.must_equal @check_out_date
    end

    it "accesses the room being reserved" do
      @reservation.must_respond_to :room
      @reservation.room.must_be_instance_of Hotel::Room
      @reservation.room.number.must_equal 1
    end

    it "accesses the cost of the reservation" do
      @reservation.must_respond_to :cost
      @reservation.cost.must_be_kind_of Float
      @reservation.cost.must_equal 400
    end

    it "raises an ArgumentError if the date range is invalid" do
      proc { Hotel::Reservation.new(@check_out_date, @check_in_date, @room) }.must_raise ArgumentError
    end

  end

end
