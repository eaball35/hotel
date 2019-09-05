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