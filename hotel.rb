require_relative './lib/front_desk.rb'
require_relative './lib/reservation.rb'
require_relative './lib/room.rb'

operations = ["Rooms", "Reservations", "Room Blocks"]
room_operations = ["List all rooms with rate", "List available rooms for a given date range"]
reservation_operations = ["List all reservations with cost", "List reservations for a specific date", "Make a reservation"]
block_operations = ["List all room blocks with date range, available rooms and discount rate", "Create a room block", "Reserve from a room block"]

def validate_choice(choices)
  user_choice = gets.chomp.to_i
  until choices.include?(user_choice)
    puts "Please make a valid choice: "
    user_choice = gets.chomp.to_i
  end
  return user_choice
end

def print_list(list)
  puts "Please make a choice from the following list:"
  list.length.times  do |i|
    puts "#{i + 1}. #{list[i]}"
  end
  puts "#{list.length + 1}. Exit"
end

def operate_rooms(choice)
end

def operate_reservations(choice)
end

def operate_blocks(choice)
end

puts "Welcome to the Hotel Booking System!"
print_list(operations)
operation = validate_choice((1..(operations.length + 1)))

until operation == operations.length + 1
  case operation
    when 1
      print_list(room_operations)
      room_operation = validate_choice((1..(room_operations.length + 1)))
      operate_rooms(room_operation)
    when 2
      print_list(reservation_operations)
      reservation_operation = validate_choice((1..(reservation_operations.length + 1)))
      operate_reservations(reservation_operation)
    when 3
      print_list(block_operations)
      block_operation = validate_choice((1..(block_operations.length + 1)))
      operate_blocks(block_operation)
  end
end
