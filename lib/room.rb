class Room
  
  attr_reader :room_number, :cost
  attr_accessor :reservations, :unavailable_dates

  def initialize(room_number, cost, reservations = [], unavailable_dates = [])
    raise ArgumentError.new("Invalid room number") if room_number.class != Integer
    
    @room_number = room_number
    @cost = cost
    @reservations = reservations
    @unavailable_dates = unavailable_dates
  end

end

# hotel = ReservationBooker.new
# hotel.add_rooms(1,200)

# booking_dates = DateChecker.new('Apr, 1 2019', 'Apr, 4 2019').booking_date_range
# first_available_room = hotel.find_first_available_room(booking_dates)
# hotel.book_reservation(first_available_room, booking_dates)
# puts first_available_room.unavailable_dates