require_relative 'input_validation'
require_relative 'room'
require_relative 'reservation'
require_relative 'booking_dates'

class ReservationBooker
    attr_accessor :rooms, :reservations, :room_blocks

    def initialize(rooms: [] , reservations: [], room_blocks: [])
      @rooms = rooms
      @reservations = reservations
      @room_blocks = room_blocks
    end

    def is_room_roomblocked?(room:, booking_date_range:)
      check_room?(room)
      check_booking_date_range?(booking_date_range)
      
      return !(room.rb_unavailable_dates & booking_date_range).empty?
    end
    
    def is_room_reserved?(room:, booking_date_range:)
      check_room?(room)
      check_booking_date_range?(booking_date_range)
      
      return !(room.unavailable_dates & booking_date_range).empty?
    end

    def find_available_rooms(booking_date_range:, roomblock: false)
      check_booking_date_range?(booking_date_range)
      check_roomblock?(roomblock)
      check_empty?(@rooms)

      found_rooms = []
      @rooms.each do |room|
        no_reservations = room.reservations.empty?
        roomblocked = is_room_roomblocked?(room: room , booking_date_range: booking_date_range)
        reserved = is_room_reserved?(room: room , booking_date_range: booking_date_range)
        
        if !roomblock
          found_rooms << room if (no_reservations && !roomblocked) || (!reserved && !roomblocked)
        else
          found_rooms << room if no_reservations || !reserved 
        end
      end  

      return found_rooms
    end
    
    def find_first_available_room(booking_date_range:, roomblock: false)
      check_booking_date_range?(booking_date_range)
      check_roomblock?(roomblock)
      
      all_available_rooms = find_available_rooms(booking_date_range: booking_date_range, roomblock: roomblock) 
      check_empty?(all_available_rooms)

      first_available_room = all_available_rooms.first
      check_room?(first_available_room)

      is_room_reserved?(room: first_available_room, booking_date_range: booking_date_range)
      is_room_roomblocked?(room: first_available_room, booking_date_range: booking_date_range) if !roomblock

      return first_available_room
    end

    def find_available_rooms_in_roomblock(room_block)
      return room_block.collection_rooms - room_block.reserved_rooms
    end

    def book_roomblock_reservation(room_block:, num_rooms: 1)
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
        reservations << book_reservation(booking_date_range: booking_date_range, roomblock: true, available_room: available_room, discount: discount)
        room_block.reserved_rooms << available_room
      end
      
      return reservations.first if num_rooms == 1
      return reservations
    end

    def book_reservation(booking_date_range:, roomblock: false, available_room: nil, discount: 0)
      check_booking_date_range?(booking_date_range)
      check_num?(discount)
      check_roomblock?(roomblock)
      
      begin
        check_room?(available_room)
      rescue NilError
        available_room = nil
      end
      
      if !roomblock && available_room == nil
        available_room = find_first_available_room(booking_date_range: booking_date_range) 
      end

      reservation = Reservation.new(room: available_room, booking_date_range: booking_date_range, discount: discount)
      @reservations << reservation
      available_room.reservations << reservation
      available_room.unavailable_dates.concat(booking_date_range)
      return reservation
    end

    def book_roomblock(num_rooms:, booking_date_range: , discount: 20)      
      max_rooms = 5

      check_num?(num_rooms)
      raise ArgumentError.new("more than max_rooms") if num_rooms > max_rooms
      check_booking_date_range?(booking_date_range)
      check_num?(discount)

      all_available_rooms = find_available_rooms(booking_date_range: booking_date_range)
      check_empty?(all_available_rooms)
      check_enough_available?(all_available_rooms, num_rooms)

      block_rooms = all_available_rooms.first(num_rooms)
      room_block = RoomBlock.new(booking_date_range: booking_date_range, collection_rooms: block_rooms, discount: discount)
      
      @room_blocks << room_block
      block_rooms.each { |room|
        room.room_blocks << room_block
        room.rb_unavailable_dates.concat(booking_date_range) 
      }
      
      return room_block
    end

    def find_totalcost_byreservation(reservation)
      check_reservation?(reservation)
      check_empty?(@reservations)

      return reservation.price
    end

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
end

