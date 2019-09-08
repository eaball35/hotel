require_relative 'input_validation'
require_relative 'reservation_booker'
require_relative 'room'

class Hotel
  attr_reader :num_rooms, :cost, :reservation_booker
  attr_accessor :rooms
    
  def initialize(num_rooms = 0, cost = 0)
    check_num?(num_rooms)
    check_num?(cost)

    @rooms = []
    @cost = cost

    num_rooms.times { rooms << Room.new(cost) } if num_rooms > 0
     
    @reservation_booker = ReservationBooker.new(@rooms)
  end
    
    # adds additional rooms to booker - input number of new rooms and cost per room
  
  def add_rooms(num_rooms,cost)
    check_num?(num_rooms)
    check_num?(cost)

    num_rooms.times do
      new_room = Room.new(cost)
      @rooms << new_room
    end
  end                  
end
