require_relative 'input_validation'

class Room
  
  attr_reader :cost
  attr_accessor :reservations, :unavailable_dates, :room_blocks, :rb_unavailable_dates

  def initialize(cost, reservations = [], unavailable_dates = [], room_blocks = [], rb_unavailable_dates = [])
    check_num(cost)

    @cost = cost
    @reservations = reservations
    @unavailable_dates = unavailable_dates
    @room_blocks = room_blocks
    @rb_unavailable_dates = rb_unavailable_dates
  end
end