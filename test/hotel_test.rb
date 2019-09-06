require_relative 'test_helper'

describe 'hotel' do
  let (:hotel)  {
    Hotel.new
  }
  let (:reservation_booker)  {
    hotel.reservation_booker
  }
  
  describe 'initialize' do
    it 'initialized default hotel with 0 num_rooms & cost, creates hotel instance with no rooms ' do
      expect(hotel).must_be_instance_of Hotel
      expect(hotel.rooms).must_equal []
    end

    it 'can initilize hotel instance with given num_rooms & cost' do
      new_hotel = Hotel.new(20,200)
      expect(new_hotel).must_be_instance_of Hotel
      expect(new_hotel.rooms.length).must_equal 20
      expect(new_hotel.rooms[0].cost).must_equal 200
    end
  end

  describe 'add_rooms' do
    it 'added new rooms instances to hotel given num_rooms + cost' do
      hotel.add_rooms(20,500)
      expect(hotel.rooms.length).must_equal 20
      expect(hotel.rooms[0].cost).must_equal 500
    end

    it 'adds new rooms to list of rooms that are already created' do
      hotel.add_rooms(1,500)
      expect(hotel.rooms.length).must_equal 1
      expect(hotel.rooms[0].cost).must_equal 500

      hotel.add_rooms(1,200)
      expect(hotel.rooms.length).must_equal 2
      expect(hotel.rooms[1].cost).must_equal 200
    end

    it 'also updates list of rooms in reservation_booker' do
      hotel.add_rooms(1,500)
      expect(hotel.rooms.length).must_equal 1
      expect(hotel.rooms[0].cost).must_equal 500
      expect(reservation_booker.rooms.length).must_equal 1

      hotel.add_rooms(1,200)
      
      expect(reservation_booker.rooms.length).must_equal 2
      expect(reservation_booker.rooms[0].cost).must_equal 500
      expect(reservation_booker.rooms[1].cost).must_equal 200
    end
  end
end