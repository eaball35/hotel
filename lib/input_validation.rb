class NilError < StandardError
end
class EmptyError < StandardError
end

def check_nil?(input)
  raise NilError.new("Nil input") if input == nil
end

def check_num?(num)
  check_nil?(num)
  raise TypeError.new("Invalid num") if num.class != Integer && num.class != Float
  raise ArgumentError.new("Negative number") if num < 0
end

def check_empty?(array)
  check_nil?(array)
  raise TypeError.new("Empty") if array.class != Array || array.empty?
end

def check_date?(date)
  check_nil?(date)
  raise TypeError.new("Invalid date") if date.class != Date
end

def check_booking_date_range?(booking_date_range)
  check_nil?(booking_date_range)
  
  raise TypeError.new("Invalid booking_date_range") if booking_date_range.class != Array || booking_date_range.empty?
    
  check_date?(booking_date_range.first)
end

def check_room?(room)
  check_nil?(room)
  raise TypeError.new("Invalid room") if room.class != Room
end

def check_roomblock?(roomblock)
  check_nil?(roomblock)
  raise TypeError.new("Invalid roomblock") if roomblock != true && roomblock != false
end

def check_room_block?(room_block)
  check_nil?(room_block)
  raise TypeError.new("Invalid room_block") if room_block.class != RoomBlock
end

def check_reservation?(reservation)
  check_nil?(reservation)
  raise TypeError.new("Invalid reservation ") if reservation.class != Reservation
end

def check_room_reserved?(room, booking_date_range)
  raise EmptyError.new("Room reserved") if !(room.unavailable_dates & booking_date_range).empty?
end

def check_enough_available?(array, number)
  raise EmptyError.new("Not enough available.") if array.length < number
end

def check_end_after_start(start_date, end_date)
  raise ArgumentError.new("Invalid date inputs") if end_date < start_date
end