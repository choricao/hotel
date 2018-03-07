require_relative './lib/front_desk.rb'
require_relative './lib/reservation.rb'
require_relative './lib/room.rb'

require 'pry'
require 'date'

operations = ["Rooms", "Reservations", "Room Blocks"]
room_operations = ["List all rooms with rate", "List available rooms for a given date range"]
reservation_operations = ["List all reservations with cost", "List reservations for a specific date", "Make a reservation"]
block_operations = ["List all room blocks with date range, available rooms and discount rate", "Create a room block", "Reserve from a room block"]
front_desk = Hotel::FrontDesk.new

def validate_choice(choices)
  user_choice = gets.chomp.to_i
  until choices.include?(user_choice)
    puts "Please make a valid choice: "
    user_choice = gets.chomp.to_i
  end
  return user_choice
end

def validate_date
  # TODO: also validate date information
  date = gets.chomp
  pattern = /\d{4}-\d{1,2}-\d{1,2}/
  until pattern.match(date)
    puts "Please enter a valid date following the provided format:"
    date = gets.chomp
  end
  return date
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
  check_in_date = Date.parse(validate_date)
  puts "Please enter check out date (yyyy-mm-dd):"
  check_out_date = Date.parse(validate_date)
  avail_rooms = front_desk.get_avail_rooms(check_in_date, check_out_date)
  puts "Here is a list of rooms available between #{check_in_date} and #{check_out_date}: "
  print_rooms(avail_rooms)
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
    choice = validate_choice((1..(room_operations.length + 1)))
  end
end

# RESERVATION

def operate_reservations(choice)
end

# BLOCK
def operate_blocks(choice)
end

# MAIN
puts "Welcome to the Hotel Booking System!"
print_list(operations)
operation = validate_choice((1..(operations.length + 1)))

until operation == operations.length + 1
  case operation
    when 1
      print_list(room_operations)
      room_choice = validate_choice((1..(room_operations.length + 1)))
      operate_rooms(room_choice, room_operations, front_desk)
    when 2
      print_list(reservation_operations)
      reservation_operation = validate_choice((1..(reservation_operations.length + 1)))
      operate_reservations(reservation_operation)
    when 3
      print_list(block_operations)
      block_operation = validate_choice((1..(block_operations.length + 1)))
      operate_blocks(block_operation)
  end
  print_list(operations)
  operation = validate_choice((1..(operations.length + 1)))
end
