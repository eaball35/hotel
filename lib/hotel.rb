require_relative 'reservation_booker'
require_relative 'room'

class Hotel
  attr_reader :num_rooms, :cost, :reservation_booker
  attr_accessor :rooms
    
  def initialize(num_rooms = 0,cost = 0)
    raise TypeError.new("invalid num_rooms inputed") if num_rooms.class != Integer
    raise TypeError.new("invalid cost inputed") if !cost.is_a? Numeric 
    
    @rooms = []
    @cost = cost

    num_rooms.times { rooms << Room.new(cost) } if num_rooms > 0
     
    @reservation_booker = ReservationBooker.new(@rooms)
  end
    
    # adds additional rooms to booker - input number of new rooms and cost per room
  
  def add_rooms(num_rooms,cost)
    raise TypeError.new("invalid num_rooms inputed") if num_rooms.class != Integer
    raise TypeError.new("invalid cost inputed") if !cost.is_a? Numeric 

    num_rooms.times do
      new_room = Room.new(cost)
      @rooms << new_room
    end
  end                  
end
