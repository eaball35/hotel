require_relative 'input_validation'
require_relative 'room'
require_relative 'reservation'
require_relative 'booking_dates'


class ReservationBooker

    attr_accessor :rooms, :reservations, :room_blocks

    def initialize(rooms = [] , reservations = [], room_blocks = [])
      @rooms = rooms
      @reservations = reservations
      @room_blocks = room_blocks
    end

    def is_room_roomblocked?(room, booking_date_range)
      check_room?(room)
      check_booking_date_range?(booking_date_range)
      
      return !(room.rb_unavailable_dates & booking_date_range).empty?
    end
    
    def is_room_reserved?(room, booking_date_range)
      check_room?(room)
      check_booking_date_range?(booking_date_range)
      
      return !(room.unavailable_dates & booking_date_range).empty?
    end

# finds the first avaiable room instance given a range of booking dates
    def find_available_rooms(booking_date_range , roomblock = false)
      check_booking_date_range?(booking_date_range)
      check_roomblock?(roomblock)
      check_empty?(@rooms)

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
      check_booking_date_range?(booking_date_range)
      check_roomblock?(roomblock)
      
      all_available_rooms = find_available_rooms(booking_date_range, roomblock) 
      check_empty?(all_available_rooms)

      first_available_room = all_available_rooms.first
      check_room?(first_available_room)

      is_room_reserved?(first_available_room, booking_date_range)
      is_room_roomblocked?(first_available_room, booking_date_range) if !roomblock

      return first_available_room
    end

    def book_reservation(booking_date_range, roomblock = false, available_room = nil, discount = 0)
      check_booking_date_range?(booking_date_range)
      check_num?(discount)
      check_roomblock?(roomblock)
      
      begin
        check_room?(available_room)
      rescue NilError
        available_room = nil
      end

      available_room = find_first_available_room(booking_date_range) if !roomblock && available_room == nil

      reservation = Reservation.new(available_room, booking_date_range, discount)
      @reservations << reservation
      available_room.reservations << reservation
      available_room.unavailable_dates.concat(booking_date_range)
      return reservation
    end

    def find_available_rooms_in_roomblock(room_block)
      return room_block.collection_rooms - room_block.reserved_rooms
    end

    def book_roomblock_reservation(room_block, num_rooms = 1)
      check_room_block?(room_block)
      check_num?(num_rooms)

      available_rooms = find_available_rooms_in_roomblock(room_block)
      check_empty?(available_rooms)
      check_enough_available?(available_rooms,num_rooms)
      
      reservation_rooms = available_rooms.first(num_rooms)
      booking_date_range = room_block.booking_date_range
      discount = room_block.discount
      reservations = []
      
      reservation_rooms.each do |available_room|
        reservations << book_reservation(booking_date_range, true, available_room, discount)
        room_block.reserved_rooms << available_room
      end
      
      return reservations.first if num_rooms == 1
      return reservations
    end

  # returns list of reservations on a given date instance
    def find_reservations_bydate(date)
      check_date?(date)
      check_empty?(@reservations)

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
      check_reservation?(reservation)
      check_empty?(@reservations)

      return reservation.price
    end

    def book_roomblock(num_rooms, booking_date_range , discount)      
      max_rooms = 5

      check_num?(num_rooms)
      check_booking_date_range?(booking_date_range)
      check_num?(discount)

      all_available_rooms = find_available_rooms(booking_date_range)
      check_empty?(all_available_rooms)
      check_enough_available?(all_available_rooms, num_rooms)

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

