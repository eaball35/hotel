class NilError < StandardError
end
class EmptyError < StandardError
end

def check_booking_date_range(booking_date_range)
  if booking_date_range == nil
    raise NilError.new("Nil booking_date_range")
  elsif booking_date_range.class != Array || booking_date_range.empty?
    raise TypeError.new("Invalid booking_date_range")
  elsif booking_date_range.first.class != Date
    raise TypeError.new("Invalid booking_date_range - incorrect dates")
  end 
end

def check_room(room)
  if room == nil
    raise NilError.new("Nil room")
  elsif room.class != Room
    raise TypeError.new("Invalid room")
  end
end

def check_roomblock(roomblock)
  if roomblock == nil
    raise NilError.new("Nil roomblock")
  elsif roomblock != true && roomblock != false
    raise TypeError.new("Invalid roomblock")
  end
end

def check_room_block(room_block)
  if room_block == nil
    raise NilError.new("Nil room_block")
  elsif room_block.class != RoomBlock
    raise TypeError.new("Invalid room_block")
  end
end

def check_empty(array)
  if array == nil
    raise NilError.new("Nil rooms")
  elsif array.class != Array
    raise TypeError.new("Invalid rooms")
  elsif array.empty?
    raise EmptyError.new("Empty array")
  end
end

def check_num(num)
  if num == nil
    raise NilError.new("Nil discount")
  elsif num.class != Integer && num.class != Float && integer < 0
    raise TypeError.new("Invalid roomblock")
  end
end

def check_date(date)
  if date == nil
    raise NilError.new("Nil date")
  elsif date.class != Date
    raise TypeError.new("Invalid date") 
  end
end

def check_reservation(reservation)
  if reservation == nil
    raise NilError.new("Nil date")
  elsif reservation.class != Reservation
    raise TypeError.new("Invalid reservation ") 
  end
end

def room_reserved?(room, booking_date_range)
  raise EmptyError.new("Room reserved") if !(room.unavailable_dates & booking_date_range).empty?
end