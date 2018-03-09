require_relative './lib/front_desk.rb'
require_relative './lib/reservation.rb'
require_relative './lib/room.rb'

require 'pry'
require 'date'

def get_valid_choice(choices)
  user_choice = gets.chomp.to_i
  until choices.include?(user_choice)
    puts "Please make a valid choice: "
    user_choice = gets.chomp.to_i
  end
  return user_choice
end

def get_valid_date
  date = gets.chomp
  pattern = /^\d{4}-\d{1,2}-\d{1,2}$/

  while true
    until pattern.match(date)
      puts "Please enter a valid date following the provided format:"
      date = gets.chomp
    end

    date_strings = date.split("-")
    date_array = date_strings.map(&:to_i)

    if Date.valid_date?(date_array[0], date_array[1], date_array[2])
      return Date.parse(date)
    else
      puts "Please enter a valid date following the provided format:"
      date = gets.chomp
    end
  end
end

def valid_date_range?(check_in_date, check_out_date)
  return check_in_date < check_out_date
end

def get_valid_room_count
  room_count = gets.chomp.to_i
  until room_count > 0 && room_count <= 5
    puts "Please enter a valid number:"
    room_count = gets.chomp.to_i
  end
  return room_count
end

def get_valid_discount
  discount = gets.chomp.to_f
  until discount >= 0 && discount <= 1
    puts "Please enter a valid number:"
    discount = gets.chomp.to_f
  end
  return discount
end

def print_list(list)
  puts "Please make a choice from the following list:"
  list.length.times  do |i|
    puts "#{i + 1}. #{list[i]}"
  end
  puts "#{list.length + 1}. Exit"
end

# ROOM
def print_rooms(rooms)
  rooms.each do |room|
    puts "Room number: #{room.number}, Rate: $#{room.rate} / night"
  end
end

def list_all_rooms(front_desk)
  all_rooms = front_desk.rooms
  puts "Here is a full list of rooms in this hotel:"
  print_rooms(all_rooms)
end

def list_avail_rooms(front_desk)
  puts "Please enter check in date (yyyy-mm-dd):"
  check_in_date = get_valid_date
  puts "Please enter check out date (yyyy-mm-dd):"
  check_out_date = get_valid_date
  until valid_date_range?(check_in_date, check_out_date)
    puts "Please enter a valid check out date (yyyy-mm-dd):"
    check_out_date = get_valid_date
  end

  avail_rooms = front_desk.get_avail_rooms(check_in_date, check_out_date)
  if avail_rooms.length == 0
    puts "There is no available room between #{check_in_date} and #{check_out_date}."
    return false
  else
    puts "Here is a list of rooms available between #{check_in_date} and #{check_out_date}: "
    print_rooms(avail_rooms)
  end
end

def operate_rooms(choice, room_operations, front_desk)
  until choice == room_operations.length + 1
    case choice
      when 1
        list_all_rooms(front_desk)
      when 2
        list_avail_rooms(front_desk)
    end
    print_list(room_operations)
    choice = get_valid_choice((1..(room_operations.length + 1)))
  end
end

# RESERVATION
def print_reservations(reservations)
  reservations.length.times do |i|
    curr_res = reservations[i]
    puts "#{i + 1}. Check in: #{curr_res.check_in_date}, Check out: #{curr_res.check_out_date}, Room: #{curr_res.room.number}, Cost: $#{curr_res.cost}"
  end
end

def list_all_reservations(front_desk)
  all_reservations = front_desk.reservations
  if all_reservations.length == 0
    puts "There is no existing reservation."
    return false
  else
    puts "Here is a list of all reservations in this hotel:"
    print_reservations(all_reservations)
    return true
  end
end

def list_reservations_for_a_date(front_desk)
  puts "Please enter the date (yyyy-mm-dd) you want to see:"
  date = get_valid_date
  reservations = front_desk.list_reservations(date)
  if reservations.length == 0
    puts "There is no existing reservation on #{date}."
    return false
  else
    puts "Here is a list of reservations on #{date}:"
    print_reservations(reservations)
    return true
  end
end

def make_reservation(front_desk)
  puts "Please enter check in date (yyyy-mm-dd):"
  check_in_date = get_valid_date
  puts "Please enter check out date (yyyy-mm-dd):"
  check_out_date = get_valid_date
  until valid_date_range?(check_in_date, check_out_date)
    puts "Please enter a valid check out date (yyyy-mm-dd):"
    check_out_date = get_valid_date
  end
  reservation = front_desk.add_reservation(check_in_date, check_out_date)
  puts "Room #{reservation.room.number} has been reserved between #{reservation.check_in_date} and #{reservation.check_out_date}. The total cost for this reservation is $#{reservation.cost}"
end

def operate_reservations(choice, reservation_operations, front_desk)
  until choice == reservation_operations.length + 1
    case choice
      when 1
        list_all_reservations(front_desk)
      when 2
        list_reservations_for_a_date(front_desk)
      when 3
        make_reservation(front_desk)
    end
    print_list(reservation_operations)
    choice = get_valid_choice((1..(reservation_operations.length + 1)))
  end
end

# BLOCK
def print_blocks(blocks)
  blocks.values.length.times do |i|
    curr_block_value = blocks.values[i]
    puts "#{i + 1}. Check in: #{curr_block_value[:check_in_date]}, Check out: #{curr_block_value[:check_out_date]}, Number of rooms available: #{curr_block_value[:rooms].length}, Discount rate: #{curr_block_value[:discount]}"
  end
end

def list_all_blocks(front_desk)
  all_blocks = front_desk.room_blocks
  if all_blocks.length == 0
    puts "These is no existing block."
    return false
  else
    puts "Here is a list of all room blocks in this hotel:"
    print_blocks(all_blocks)
    return true
  end
end

def add_block(front_desk)
  puts "Please enter check in date (yyyy-mm-dd):"
  check_in_date = get_valid_date
  puts "Please enter check out date (yyyy-mm-dd):"
  check_out_date = get_valid_date
  puts "How many rooms do you want to put in this room block? ( 0 < number <= 5 )"
  room_count = get_valid_room_count
  puts "What is the discount rate (e.g. enter 0.8 for '20% OFF') for this block? ( 0.0 <= rate <= 1.0 )"
  discount = get_valid_discount
  block_value = front_desk.create_room_block(check_in_date, check_out_date, room_count, discount)
  puts "A block with #{room_count} rooms between #{check_in_date} and #{check_out_date} has been added. The discount rate is #{discount}."
end

def reserve_from_block(front_desk)
  if list_all_blocks(front_desk)
    puts "Please choose the block you want to reserve from:"
    block_id = (gets.chomp.to_i - 1).to_s
    reservation = front_desk.reserve_from_block(block_id)
    reservation.cost *= front_desk.room_blocks[block_id][:discount]
    puts "Room #{reservation.room.number} has been reserved between #{reservation.check_in_date} and #{reservation.check_out_date} from the current block. The total cost for this reservation is $#{reservation.cost}"
  end
end

def operate_blocks(choice, block_operations, front_desk)
  until choice == block_operations.length + 1
    case choice
      when 1
        list_all_blocks(front_desk)
      when 2
        add_block(front_desk)
      when 3
        reserve_from_block(front_desk)
    end
    print_list(block_operations)
    choice = get_valid_choice((1..(block_operations.length + 1)))
  end
end

# MAIN
operations = ["Rooms", "Reservations", "Room Blocks"]
room_operations = ["List all rooms", "List available rooms for a given date range"]
reservation_operations = ["List all reservations", "List reservations for a specific date", "Make a reservation"]
block_operations = ["List all room blocks", "Create a room block", "Reserve room from a block"]
front_desk = Hotel::FrontDesk.new

puts "Welcome to the Hotel Booking System!"
print_list(operations)
operation = get_valid_choice((1..(operations.length + 1)))

until operation == operations.length + 1
  case operation
    when 1
      print_list(room_operations)
      room_choice = get_valid_choice((1..(room_operations.length + 1)))
      operate_rooms(room_choice, room_operations, front_desk)
    when 2
      print_list(reservation_operations)
      reservation_choice = get_valid_choice((1..(reservation_operations.length + 1)))
      operate_reservations(reservation_choice, reservation_operations, front_desk)
    when 3
      print_list(block_operations)
      block_choice = get_valid_choice((1..(block_operations.length + 1)))
      operate_blocks(block_choice, block_operations, front_desk)
  end
  print_list(operations)
  operation = get_valid_choice((1..(operations.length + 1)))
end
