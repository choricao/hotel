require_relative 'spec_helper'

describe "FrontDesk" do
  before do
    @front_desk = Hotel::FrontDesk.new
  end

  describe "initialize" do

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

  describe "add_reservation" do
    before do
      @check_in_date = Date.new(2018, 3, 5)
      @check_out_date = Date.new(2018, 3, 7)
    end

    it "creates a new instance of Reservation with the date range provided" do
      reservation = @front_desk.add_reservation(@check_in_date, @check_out_date)

      reservation.must_be_instance_of Hotel::Reservation
    end

    it "assigns a room from the available room list" do
      reservation = @front_desk.add_reservation(@check_in_date, @check_out_date)

      reservation.room.must_be_instance_of Hotel::Room
      @front_desk.get_avail_rooms(@check_in_date, @check_out_date).include?(reservation.room).must_equal false
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

    it "raises an Exception if there is no room available" do
      20.times do
        @front_desk.add_reservation(Date.new(2018, 3, 5), Date.new(2018, 3, 7))
      end

      proc { @front_desk.add_reservation(Date.new(2018, 3, 5), Date.new(2018, 3, 7)) }.must_raise Exception
    end

  end

  describe "list_reservations" do
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
      proc { @front_desk.list_reservations(1) }.must_raise ArgumentError
    end

  end

  describe "get_avail_rooms" do

    it "returns a list of empty rooms for a given date range" do
      @front_desk.add_reservation(Date.new(2018, 3, 5), Date.new(2018, 3, 7))
      @front_desk.add_reservation(Date.new(2018, 3, 6), Date.new(2018, 3, 8))
      @front_desk.add_reservation(Date.new(2018, 3, 7), Date.new(2018, 3, 9))

      @front_desk.get_avail_rooms(Date.new(2018, 3, 5), Date.new(2018, 3, 6)).length.must_equal 19
      @front_desk.get_avail_rooms(Date.new(2018, 3, 5), Date.new(2018, 3, 7)).length.must_equal 18
      @front_desk.get_avail_rooms(Date.new(2018, 3, 5), Date.new(2018, 3, 8)).length.must_equal 17
    end

    it "returns an empty array if no empty room exists for a given date range" do
        20.times do
          @front_desk.add_reservation(Date.new(2018, 3, 5), Date.new(2018, 3, 7))
        end

        @front_desk.get_avail_rooms(Date.new(2018, 3, 4), Date.new(2018, 3, 5)).length.must_equal 20
        @front_desk.get_avail_rooms(Date.new(2018, 3, 5), Date.new(2018, 3, 6)).length.must_equal 0
        @front_desk.get_avail_rooms(Date.new(2018, 3, 6), Date.new(2018, 3, 7)).length.must_equal 0
        @front_desk.get_avail_rooms(Date.new(2018, 3, 7), Date.new(2018, 3, 8)).length.must_equal 20
    end

    it "raises an ArgumentError if the date range is invalid" do
      proc { @front_desk.get_avail_rooms(1, 2) }.must_raise ArgumentError
    end

    it "does not return a room from any room block" do
      @front_desk.add_reservation(Date.new(2018, 3, 5), Date.new(2018, 3, 7))
      room_block = @front_desk.create_room_block(Date.new(2018, 3, 5), Date.new(2018, 3, 7), 5, 0.9)

      avail_rooms = @front_desk.get_avail_rooms(Date.new(2018, 3, 5), Date.new(2018, 3, 7))

      avail_rooms.length.must_equal 14
      (room_block[:rooms] & avail_rooms).must_equal []
    end

  end

  describe "create_room_block" do

    it "returns a room block hash" do
      room_block = @front_desk.create_room_block(Date.new(2018, 3, 5), Date.new(2018, 3, 7), 5, 0.9)

      room_block[:rooms].length.must_equal 5
      room_block[:rooms].each do |room|
        room.must_be_instance_of Hotel::Room
      end
      room_block[:check_in_date].must_equal Date.new(2018, 3, 5)
      room_block[:check_out_date].must_equal Date.new(2018, 3, 7)
      room_block[:discount].must_equal 0.9
    end

    it "updates the room block list" do
      orig_number = @front_desk.room_blocks.length

      room_block = @front_desk.create_room_block(Date.new(2018, 3, 5), Date.new(2018, 3, 7), 5, 0.9)

      @front_desk.room_blocks.length.must_equal orig_number + 1
      @front_desk.room_blocks.values.include?(room_block).must_equal true
    end

    it "raises an Exception if there is not enough rooms available for creating the block" do
      16.times do
        @front_desk.add_reservation(Date.new(2018, 3, 5), Date.new(2018, 3, 7))
      end

      proc { @front_desk.create_room_block(Date.new(2018, 3, 5), Date.new(2018, 3, 7), 5, 0.9) }.must_raise Exception
    end

    it "raises an Exception if room count is invalid" do
      proc { room_block = @front_desk.create_room_block(Date.new(2018, 3, 5), Date.new(2018, 3, 7), 0, 0.9) }.must_raise Exception
    end

  end

  describe "reserve_from_block" do
    before do
      @room_block = @front_desk.create_room_block(Date.new(2018, 3, 5), Date.new(2018, 3, 7), 5, 0.9)
    end

    it "creates a new instance of Reservation" do
      reservation = @front_desk.reserve_from_block("0")

      reservation.must_be_instance_of Hotel::Reservation
    end

    it "assigns a room from the room block and remove it from list" do
      reservation = @front_desk.reserve_from_block("0")

      @room_block[:rooms].include?(reservation.room).must_equal false
      @room_block[:rooms].length.must_equal 4
    end

    it "returns reservation with correct date range" do
      reservation = @front_desk.reserve_from_block("0")

      reservation.check_in_date.must_equal Date.new(2018, 3, 5)
      reservation.check_out_date.must_equal Date.new(2018, 3, 7)
    end

    it "adds the new reservation to the reservation list" do
      orig_number = @front_desk.reservations.length

      reservation = @front_desk.reserve_from_block("0")

      @front_desk.reservations.length.must_equal orig_number + 1
      @front_desk.reservations.include?(reservation).must_equal true
    end


    it "raises an Exception if there is no room available from that room block" do
      proc { 6.times {@front_desk.reserve_from_block("0")} }.must_raise Exception
    end

  end

  describe "get_avail_rooms_from_block" do
    before do
      @room_block = @front_desk.create_room_block(Date.new(2018, 3, 5), Date.new(2018, 3, 7), 5, 0.9)
    end

    it "returns a list of rooms available in that block" do
      rooms = @front_desk.get_avail_rooms_from_block("0")

      rooms.length.must_equal 5
      rooms.each do |room|
        room.must_be_instance_of Hotel::Room
      end
    end

    it "raises an Exception if no room available in that block" do
      5.times do
        @front_desk.reserve_from_block("0")
      end

      proc { @front_desk.get_avail_rooms_from_block("0") }.must_raise Exception
    end

  end

end
