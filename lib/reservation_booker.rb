require_relative 'Room'
require_relative 'Reservation'
require_relative 'Date_Checker'
require 'pry'

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
        # need to map dates into map
        room_unavailable_dates = room_reservations.map { |reservation| reservation.booking_date_range}
        if room_reservations.empty?
          return room 
        elsif (room_unavailable_dates & booking_date_range).empty?
          return room 
        end
      end
      return nil
    end

    def book_reservation(room, booking_date_range)
      reservation = Reservation.new(room, booking_date_range)
      @reservations << reservation
      room.reservations << reservation
      return reservation
    end
end
