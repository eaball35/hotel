require_relative 'room'
require_relative 'reservation'
require_relative 'date_checker'

class ReservationBooker
    
    attr_accessor :rooms, :reservations

    def initialize
      @rooms = []
      @reservations = []
    end

    def add_rooms(num_rooms,cost)
      raise ArgumentError.new("invalid num_rooms inputed") if num_rooms.class != Integer
      raise ArgumentError.new("invalid cost inputed") if !cost.is_a? Numeric 

      num_rooms.times do |num|
        @rooms << Room.new((num + 1),cost)
      end                         
    end

    def find_first_available_room(booking_date_range)
      raise ArgumentError.new("No rooms added yet") if @rooms == []

      @rooms.each do |room|
        room_reservations = room.reservations
        room_unavailable_dates = room.unavailable_dates
        if room_reservations.empty?
          return room 
        elsif (room_unavailable_dates & booking_date_range).empty?
          return room 
        end
      end
      return nil
    end

    def book_reservation(avaible_room, booking_date_range)
      if avaible_room.class != Room
        raise ArgumentError.new("Room input isn't valid")
      elsif booking_date_range.class != Array
        raise ArgumentError.new("Booking dates input isn't valid")
      elsif booking_date_range[0].class != Date
        raise ArgumentError.new("Booking dates input isn't valid - dates aren't Dates")
      end
      
      reservation = Reservation.new(avaible_room, booking_date_range)
      @reservations << reservation
      avaible_room.reservations << reservation
      avaible_room.unavailable_dates.concat(booking_date_range)
      return reservation
    end

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
end
