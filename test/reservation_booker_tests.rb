require_relative 'test_helper'
require_relative '../lib/reservation_booker'
require 'pry'


describe 'reservation_booker tests' do
    describe 'initialize' do
      it 'new instance of Reservation_Booker is created with empty rooms and reservations' do
          reservation_booker_test = ReservationBooker.new
          rooms = reservation_booker_test.rooms
          reservations = reservation_booker_test.reservations

          expect(reservation_booker_test).must_be_instance_of ReservationBooker
          expect(rooms).must_equal []
          expect(reservations).must_equal []
      end
    end

    describe 'add_rooms tests' do
    
      it 'raise error if num_rooms is invalid' do
        reservation_booker_test = ReservationBooker.new
        
        expect{reservation_booker_test.add_rooms("45",200)}.must_raise ArgumentError
        expect{reservation_booker_test.add_rooms([],200)}.must_raise ArgumentError
      end

      it 'raise error if cost is invalid' do
        reservation_booker_test = ReservationBooker.new
        
        expect{reservation_booker_test.add_rooms(2,"200")}.must_raise ArgumentError
        expect{reservation_booker_test.add_rooms([2],[200])}.must_raise ArgumentError
      end

      it 'adds new instances of Room with given cost for number of rooms times to @rooms variable' do
        reservation_booker_test = ReservationBooker.new
        reservation_booker_test.add_rooms(20,200)

        expect(reservation_booker_test.rooms[0]).must_be_instance_of Room
        expect(reservation_booker_test.rooms.length).must_equal 20
    end
  end

  describe 'find_first_available_room tests' do
  it 'raises error if no rooms added' do
    reservation_booker_test = ReservationBooker.new
    new_booking_dates = DateChecker.new('Apr, 1 2019', 'Apr, 9 2019').booking_date_range
    expect{reservation_booker_test.find_first_available_room(new_booking_dates)}.must_raise ArgumentError
  end

  it 'returns the first available room' do
    #broken
    hotel = ReservationBooker.new
    hotel.add_rooms(2,200)
    room_one = hotel.rooms[0]
    room_two = hotel.rooms[1]
    
    booking_dates = DateChecker.new('Apr, 1 2019', 'Apr, 9 2019').booking_date_range
    first_available_room = hotel.find_first_available_room(booking_dates)

    expect(first_available_room).must_be_instance_of Room
    expect(first_available_room).must_equal room_one

    second_available_room = hotel.find_first_available_room(booking_dates)
    
    expect(second_available_room).must_be_instance_of Room
    expect(second_available_room).must_equal room_two


  end

  it 'returns nil if no available rooms for date range' do
    #broken
    hotel = ReservationBooker.new
    hotel.add_rooms(1,200)
    
    booking_dates = DateChecker.new('Apr, 1 2019', 'Apr, 9 2019').booking_date_range
    
    available_room = hotel.find_first_available_room(booking_dates)
    reservation = hotel.book_reservation(available_room, booking_dates)

    next_available_room = hotel.find_first_available_room(booking_dates)
    expect(next_available_room).must_equal nil
  end

  end


end
