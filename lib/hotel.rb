require_relative 'reservation_booker'
require_relative 'room'

class Hotel

  attr_reader :num_rooms, :cost, :reservation_booker
  attr_accessor :rooms
    
  def initialize(num_rooms = 0,cost = 0)
    raise ArgumentError.new("invalid num_rooms inputed") if num_rooms.class != Integer
    raise ArgumentError.new("invalid cost inputed") if !cost.is_a? Numeric 
    
    if num_rooms == 0
      @rooms = []
    else
      num_rooms.times { |num| @rooms << Room.new((num + 1),cost) }
    end 
    
    @reservation_booker = ReservationBooker.new
  end
    
    # adds additional rooms to booker - input number of new rooms and cost per room
  def add_rooms(num_rooms,cost)
    raise ArgumentError.new("invalid num_rooms inputed") if num_rooms.class != Integer
    raise ArgumentError.new("invalid cost inputed") if !cost.is_a? Numeric 

    num_rooms.times do |num|
      @rooms << Room.new((num + 1),cost)
    end 
    @reservation_booker.rooms = @rooms                        
  end
end

  