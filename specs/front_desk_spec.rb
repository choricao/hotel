require_relative 'spec_helper'

describe "FrontDesk" do
  before do
    @front_desk = Hotel::FrontDesk.new
  end

  xdescribe "initialize" do

    it "creates an instance of FrontDesk" do
      @front_desk.must_be_instance_of Hotel::FrontDesk
    end

    it "accesses the list of rooms" do
      @front_desk.must_respond_to :rooms
      @front_desk.rooms.must_be_kind_of Array
      @front_desk.rooms.each do |room|
        room.must_be_instance_of Hotel::Room
      end
    end

    it "accesses the list of reservations" do
      @front_desk.must_respond_to :reservations
      @front_desk.reservations.must_be_kind_of Array
      @front_desk.reservations.length.must_equal 0
    end

  end

  xdescribe "add_reservation" do
    before do
      @check_in_date = Date.new(2018, 3, 5)
      @check_out_date = Date.new(2018, 3, 7)
    end

    it "creates a new instance of Reservation with the date range provided" do
      reservation = @front_desk.add_reservation(@check_in_date, @check_out_date)

      reservation.must_be_instance_of Hotel::Reservation
    end

    it "assigns a room from the room list" do
      reservation = @front_desk.add_reservation(@check_in_date, @check_out_date)

      reservation.room.must_be_instance_of Hotel::Room
      @front_desk.rooms.include?(reservation.room).must_equal true
    end

    it "adds the new reservation to the reservation list" do
      orig_number = @front_desk.reservations.length

      reservation = @front_desk.add_reservation(@check_in_date, @check_out_date)

      @front_desk.reservations.length.must_equal orig_number + 1
      @front_desk.reservations.include?(reservation).must_equal true
    end

    it "returns the newly created reservation" do
      reservation = @front_desk.add_reservation(@check_in_date, @check_out_date)

      reservation.check_in_date.must_equal @check_in_date
      reservation.check_out_date.must_equal @check_out_date
      (1..20).to_a.include?(reservation.room.number).must_equal true
    end

    it "raises an ArgumentError if the date range is invalid" do
      proc { @front_desk.add_reservation(@check_out_date, @check_in_date) }.must_raise ArgumentError
    end

  end

  xdescribe "list_reservations" do
    before do
      @front_desk.add_reservation(Date.new(2018, 3, 5), Date.new(2018, 3, 7))
      @front_desk.add_reservation(Date.new(2018, 3, 6), Date.new(2018, 3, 8))
      @front_desk.add_reservation(Date.new(2018, 3, 7), Date.new(2018, 3, 9))
    end

    it "returns a list of reservations on a specific date" do
      reservations = @front_desk.list_reservations(Date.new(2018, 3, 6))

      reservations.length.must_equal 2
    end

    it "returns empty array if no reservation exists on that date" do
      reservations = @front_desk.list_reservations(Date.new(2018, 3, 10))

      reservations.length.must_equal 0
    end

    it "raises an ArgumentError if the date is invalid" do
      proc { reservations = @front_desk.list_reservations(1) }.must_raise ArgumentError
    end

  end

  describe "list_empty_rooms" do
    before do
      @front_desk.add_reservation(Date.new(2018, 3, 5), Date.new(2018, 3, 7))
    end

    it "returns a list of empty rooms on a specific date" do
      @front_desk.list_empty_rooms(Date.new(2018, 3, 4)).length.must_equal 20
      @front_desk.list_empty_rooms(Date.new(2018, 3, 5)).length.must_equal 19
      @front_desk.list_empty_rooms(Date.new(2018, 3, 7)).length.must_equal 20
    end

    it "returns an empty array if no empty room exists on that date" do

    end

  end



end
