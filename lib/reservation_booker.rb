require_relative 'room'
require_relative 'reservation'
require_relative 'date_checker'

class ReservationBooker
    
    attr_accessor :rooms, :reservations, :room_blocks

    def initialize(rooms = [] , reservations = [], room_blocks = [])
      @rooms = rooms
      @reservations = reservations
      @room_blocks = room_blocks
    end

    def is_room_roomblocked?(room, booking_date_range)
      raise ArgumentError.new("Invalid input") if room.class != Room || booking_date_range.class != Array
      return !(room.rb_unavailable_dates & booking_date_range).empty?
    end

    def is_room_reserved?(room, booking_date_range)
      raise ArgumentError.new("Invalid input") if room.class != Room || booking_date_range.class != Array
      return !(room.unavailable_dates & booking_date_range).empty?
    end

# finds the first avaiable room instance given a range of booking dates
    def find_available_rooms(booking_date_range , include_roombook = true)
      raise ArgumentError.new("No rooms added yet") if @rooms == []

      found_rooms = []

      @rooms.each do |room|
        no_reservations = room.reservations.empty?
        roomblocked = is_room_roomblocked?(room , booking_date_range)
        reserved = is_room_reserved?(room , booking_date_range)
        
        if include_roombook
          found_rooms << room if (no_reservations && !roomblocked) || (!reserved && !roomblocked)
        else
          found_rooms << room if no_reservations || !reserved 
        end
      end  
      return found_rooms
    end

# books a new reservation given an available room and booking date range
# adds the new reservation to list of hotel reservations, the rooms reservations list, & adds the booking dates range to the rooms unavailable dates
    def book_reservation(booking_date_range, include_roombook = true)
      all_available_rooms = find_available_rooms(booking_date_range, include_roombook)      
      raise ArgumentError.new("No available rooms") if all_available_rooms == []

      first_available_room = all_available_rooms.first
      
      if first_available_room.class != Room
        raise ArgumentError.new("Room input isn't valid")
      elsif booking_date_range.class != Array
        raise ArgumentError.new("Booking dates input isn't valid")
      elsif booking_date_range.first.class != Date
        raise ArgumentError.new("Booking dates input isn't valid - dates aren't Dates")
      end 

      if first_available_room.unavailable_dates != []
        if !(first_available_room.unavailable_dates & booking_date_range).empty?
          raise ArgumentError.new("Room already booked during these dates")
        end
      end

      if !(booking_date_range & first_available_room.rb_unavailable_dates).empty?
        raise ArgumentError.new("Room saved for room block ")
      end

      
      reservation = Reservation.new(first_available_room, booking_date_range)
      @reservations << reservation
      first_available_room.reservations << reservation
      first_available_room.unavailable_dates.concat(booking_date_range)
      return reservation
    end

  # returns list of reservations on a given date instance
    def find_reservations_bydate(date)
      raise ArgumentError.new("invalid input date") if date.class != Date
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
      raise ArgumentError.new('Invalid reservation input') if reservation.class != Reservation
      raise ArgumentError.new('Not a current reservation') if !@reservations.include?(reservation)

      return reservation.price
    end

    def book_roomblock(num_rooms, booking_date_range , discount)
      max_rooms = 5
      raise ArgumentError.new("num_rooms is invalid") if num_rooms.class != Integer && num_rooms > max_rooms
      raise ArgumentError.new("booking_date_range is invalid") if booking_date_range.class != Array
      raise ArgumentError.new("discount is invalid")if discount.class != Integer && discount < 0
      
      all_available_rooms = find_available_rooms(booking_date_range)
      
      if all_available_rooms == []
        raise ArgumentError.new("No available rooms") 
      elsif all_available_rooms.length < num_rooms
        raise ArgumentError.new("Not enough rooms available for #{num_rooms} size block.") 
      end

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

