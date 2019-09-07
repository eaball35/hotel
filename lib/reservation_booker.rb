require_relative 'room'
require_relative 'reservation'
require_relative 'date_checker'

class ReservationBooker
    
    attr_accessor :rooms, :reservations, :room_block

    def initialize(rooms = [] , reservations = [], room_blocks = [])
      @rooms = rooms
      @reservations = reservations
      @room_blocks = room_blocks
    end

# finds the first avaiable room instance given a range of booking dates
    def find_first_available_room(booking_date_range)
      raise ArgumentError.new("No rooms added yet") if @rooms == []

      @rooms.each do |room|
        if room.reservations.empty?
          return room 
        elsif (room.unavailable_dates & booking_date_range).empty?
          return room 
        end
      end
      return nil
    end

# books a new reservation given an available room and booking date range
# adds the new reservation to list of hotel reservations, the rooms reservations list, & adds the booking dates range to the rooms unavaible dates
    def book_reservation(booking_date_range)
      avaible_room = find_first_available_room(booking_date_range)
      
      if avaible_room == nil
        raise ArgumentError.new("No rooms are available")  
      elsif avaible_room.class != Room
        raise ArgumentError.new("Room input isn't valid")
      elsif booking_date_range.class != Array
        raise ArgumentError.new("Booking dates input isn't valid")
      elsif booking_date_range[0].class != Date
        raise ArgumentError.new("Booking dates input isn't valid - dates aren't Dates")
      end 

      if avaible_room.unavailable_dates != nil
        if !(avaible_room.unavailable_dates & booking_date_range).empty?
          raise ArgumentError.new("Room already booked during these dates")
        end
      end
      
      reservation = Reservation.new(avaible_room, booking_date_range)
      @reservations << reservation
      avaible_room.reservations << reservation
      avaible_room.unavailable_dates.concat(booking_date_range)
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

# returns list of avaible rooms on a given date instance    
    def find_available_rooms_bydates(booking_date_range)
      raise ArgumentError.new("No rooms added yet") if @rooms == []
      raise ArgumentError.new ("Date input is invalid") if booking_date_range[0].class != Date
        
      found_rooms = []

      @rooms.each do |room|
        if room.reservations.empty? 
          found_rooms << room 
        elsif (room.unavailable_dates & booking_date_range).empty?
          found_rooms << room 
        end
      end
      
      if found_rooms.empty?
        return nil
      else
        return found_rooms
      end
    end

    def find_totalcost_byreservation(reservation)
      raise ArgumentError.new('Invalid reservation input') if reservation.class != Reservation
      raise ArgumentError.new('Not a current reservation') if !@reservations.include?(reservation)

      return reservation.price
    end

    def book_roomblock(num_rooms, booking_date_range , discount)
      collection_rooms = (find_available_rooms_bydates(booking_date_range)).first(num_rooms)
      
      room_block = RoomBlock.new(booking_date_range, collection_rooms, discount)
      @room_blocks << room_block

      collection_rooms.each { |room|
        room.room_blocks << room_block
        room.rb_unavailable_dates << booking_date_range
      }
      return room_block
    end

end

# reservation = Reservation.new(avaible_room, booking_date_range)
# @reservations << reservation
# avaible_room.reservations << reservation
# avaible_room.unavailable_dates.concat(booking_date_range)
# return reservation
# end

