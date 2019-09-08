require_relative 'room'
require_relative 'reservation'
require_relative 'date_checker'

class ReservationBooker
  class NilError < StandardError
  end
  class EmptyError < StandardError
  end

    attr_accessor :rooms, :reservations, :room_blocks

    def initialize(rooms = [] , reservations = [], room_blocks = [])
      @rooms = rooms
      @reservations = reservations
      @room_blocks = room_blocks
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

    def check_no_rooms(rooms)
      if rooms == nil
        raise NilError.new("Nil rooms")
      elsif rooms.class != Array
        raise TypeError.new("Invalid rooms")
      elsif rooms.empty?
        raise EmptyError.new("No rooms")
      end
    end

    def check_num(num)
      if num == nil
        raise NilError.new("Nil discount")
      elsif num.class != Integer && num.class != Float && integer < 0
        raise TypeError.new("Invalid roomblock")
      end
    end


    def is_room_roomblocked?(room, booking_date_range)
      check_room(room)
      check_booking_date_range(booking_date_range)
      
      return !(room.rb_unavailable_dates & booking_date_range).empty?
    end

    def is_room_reserved?(room, booking_date_range)
      check_room(room)
      check_booking_date_range(booking_date_range)
      
      return !(room.unavailable_dates & booking_date_range).empty?
    end

# finds the first avaiable room instance given a range of booking dates
    def find_available_rooms(booking_date_range , roomblock = false)
      check_booking_date_range(booking_date_range)
      check_roomblock(roomblock)
      check_no_rooms(@rooms)

      found_rooms = []
      @rooms.each do |room|
        no_reservations = room.reservations.empty?
        roomblocked = is_room_roomblocked?(room , booking_date_range)
        reserved = is_room_reserved?(room , booking_date_range)
        
        if !roomblock
          found_rooms << room if (no_reservations && !roomblocked) || (!reserved && !roomblocked)
        else
          found_rooms << room if no_reservations || !reserved 
        end
      end  

      return found_rooms
    end
    
    def find_first_available_room(booking_date_range, roomblock = false)
      check_booking_date_range(booking_date_range)
      check_roomblock(roomblock)
      
      all_available_rooms = find_available_rooms(booking_date_range, roomblock) 
      check_no_rooms(all_available_rooms)

      first_available_room = all_available_rooms.first
      check_room(first_available_room)

      is_room_reserved?(first_available_room, booking_date_range)
      is_room_roomblocked?(first_available_room, booking_date_range) if !roomblock

      return first_available_room
    end

    def book_reservation(booking_date_range, roomblock = false, available_room = nil, discount = 0)
      check_booking_date_range(booking_date_range)
      check_roomblock(roomblock)
      begin
        check_room(available_room)
      rescue NilError
        available_room = nil
      end
      check_num(discount)

      available_room = find_first_available_room(booking_date_range) if !roomblock

      reservation = Reservation.new(available_room, booking_date_range, discount)
      @reservations << reservation
      available_room.reservations << reservation
      available_room.unavailable_dates.concat(booking_date_range)
      return reservation
    end

    def book_roomblock_reservation(room_block, num_rooms = 1)
      check_room_block(room_block)
      check_num(num_rooms)

      booking_date_range = room_block.booking_date_range
      available_room = room_block.collection_rooms.first
      reservations = []

      num_rooms.times {reservations << book_reservation(booking_date_range, true, available_room)}
      
      return reservations.first if num_rooms == 1
      return reservations
    end

  # returns list of reservations on a given date instance
    def find_reservations_bydate(date)
      raise TypeError.new("invalid input date") if date.class != Date
      return nil if @reservations.empty?

      found_reservations = []
      @reservations.each do |reservation|
        reservation.booking_date_range.each do |booking_date|
          if booking_date == date
            found_reservations << reservation
            break
          end
        end
      end
      return found_reservations
    end

    def find_totalcost_byreservation(reservation)
      raise TypeError.new('Invalid reservation input') if reservation.class != Reservation
      raise EmptyError.new('Not a current reservation') if !@reservations.include?(reservation)
      check_no_rooms(@reservations)

      return reservation.price
    end

    def book_roomblock(num_rooms, booking_date_range , discount)      
      max_rooms = 5

      check_num(num_rooms)
      check_booking_date_range(booking_date_range)
      check_num(discount)

      all_available_rooms = find_available_rooms(booking_date_range)
      
      check_no_rooms(all_available_rooms)
      raise EmptyError.new("Not enough rooms available.") if all_available_rooms.length < num_rooms

      block_rooms = all_available_rooms.first(num_rooms)
      room_block = RoomBlock.new(booking_date_range, block_rooms, discount)
      
      @room_blocks << room_block
      block_rooms.each { |room|
        room.room_blocks << room_block
        room.rb_unavailable_dates.concat(booking_date_range) 
      }
      
      return room_block
    end

end

