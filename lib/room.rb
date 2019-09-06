class Room
  
  attr_reader :room_number, :cost
  attr_accessor :reservations, :unavailable_dates

  def initialize(cost, reservations = [], unavailable_dates = [])
    if cost.class == Integer || cost.class == Float
      @cost = cost
    else
      raise ArgumentError.new("Invalid cost input")
    end

    @reservations = reservations
    @unavailable_dates = unavailable_dates
  end
end