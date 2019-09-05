require_relative 'test_helper'

describe 'reservation_booker' do
  let (:hotel)  {
    ReservationBooker.new
  }
  let (:hotel_rooms)  {
    hotel.rooms
  }
  let (:hotel_reservations)  {
    hotel.reservations
  }
  let (:new_booking_dates)  {
    DateChecker.new('Apr, 1 2019', 'Apr, 4 2019').booking_date_range
  }
  

    describe 'initialize' do
      it 'new instance of Reservation_Booker is created with empty rooms and reservations' do
          expect(hotel).must_be_instance_of ReservationBooker
          expect(hotel_rooms).must_equal []
          expect(hotel_reservations).must_equal []
      end
    end

    describe 'add_rooms' do
    
      it 'raise error if num_rooms is invalid' do
        expect{hotel.add_rooms("45",200)}.must_raise ArgumentError
        expect{hotel.add_rooms([],200)}.must_raise ArgumentError
      end

      it 'raise error if cost is invalid' do    
        expect{hotel.add_rooms(2,"200")}.must_raise ArgumentError
        expect{hotel.add_rooms([2],[200])}.must_raise ArgumentError
      end

      it 'adds new instances of Room with given cost for number of rooms times to @rooms variable' do
        hotel.add_rooms(20,200)

        expect(hotel_rooms[0]).must_be_instance_of Room
        expect(hotel_rooms.length).must_equal 20
    end
  end

  describe 'find_first_available_room' do
    it 'raises error if no rooms added' do
      expect{hotel.find_first_available_room(new_booking_dates)}.must_raise ArgumentError
    end

    it 'returns the first available room, skip room when not available'  do
      hotel.add_rooms(2,200)
      
      available_room1 = hotel.find_first_available_room(new_booking_dates)
      hotel.book_reservation(available_room1, new_booking_dates)

      expect(available_room1).must_be_instance_of Room

      available_room2 = hotel.find_first_available_room(new_booking_dates)
      
      expect(available_room2).must_be_instance_of Room
      expect(available_room2).wont_equal available_room1
    end

    it 'returns nil if no available rooms for date range' do
      hotel.add_rooms(1,200)
      
      available_room1 = hotel.find_first_available_room(new_booking_dates)
      hotel.book_reservation(available_room1, new_booking_dates)

      available_room2 = hotel.find_first_available_room(new_booking_dates)
      expect(available_room2).must_be_nil
    end

    it 'returns first room if hotel has rooms, but no bookings yet' do
      hotel.add_rooms(20,200)
      
      available_room = hotel.find_first_available_room(new_booking_dates)
      
      expect(available_room).must_be_instance_of Room
      expect(available_room).must_equal hotel_rooms[0]
    end
  
    it 'allows reservation on the same day that another previous reservation ends' do
      hotel.add_rooms(1,200)
      new_booking_dates2 = DateChecker.new('Apr, 4 2019', 'Apr, 7 2019').booking_date_range
      
      available_room1 = hotel.find_first_available_room(new_booking_dates)
      hotel.book_reservation(available_room1, new_booking_dates)

      available_room2 = hotel.find_first_available_room(new_booking_dates2)
      hotel.book_reservation(available_room2, new_booking_dates2)
      
      expect(available_room2).wont_be_nil
      expect(available_room2).must_equal available_room1
      expect(hotel.reservations.length).must_equal 2
    end
  end

  describe 'book_reservation' do
    it 'raises error if room input is invalid'do
      hotel.add_rooms(1,200)
      
      expect{hotel.book_reservation("room", new_booking_dates)}.must_raise ArgumentError
      expect{hotel.book_reservation(20, new_booking_dates)}.must_raise ArgumentError
      expect{hotel.book_reservation(nil, new_booking_dates)}.must_raise ArgumentError
    end

    it 'raises error if booking dates input is invalid'do
      hotel.add_rooms(1,200)
      available_room1 = hotel.find_first_available_room(new_booking_dates)

      expect{hotel.book_reservation(available_room1, "booking_dates")}.must_raise ArgumentError
      expect{hotel.book_reservation(available_room1, 20)}.must_raise ArgumentError
      expect{hotel.book_reservation(available_room1, nil)}.must_raise ArgumentError
    end

    it 'raises error if booking dates input not contains Dates' do
      hotel.add_rooms(1,200)
      available_room = hotel.find_first_available_room(new_booking_dates)

      expect{hotel.book_reservation(available_room, ['Apr, 1 2019', 'Apr, 4 2019'])}.must_raise ArgumentError
    end

    it 'returns new reservation given available room and booking dates' do
      hotel.add_rooms(1,200)
      available_room = hotel.find_first_available_room(new_booking_dates)
      new_reservation = hotel.book_reservation(available_room, new_booking_dates)

      expect(new_reservation).must_be_instance_of Reservation
      expect(new_reservation.room).must_equal available_room
      expect(new_reservation.booking_date_range).must_equal new_booking_dates
    end

    
    it 'new reservation should be added to rooms list of reservations' do
      hotel.add_rooms(1,200)
      new_booking_dates2 = DateChecker.new('Apr, 6 2019', 'Apr, 10 2019').booking_date_range
      
      available_room1 = hotel.find_first_available_room(new_booking_dates)
      reservation1 = hotel.book_reservation(available_room1, new_booking_dates)
      
      available_room2 = hotel.find_first_available_room(new_booking_dates2)
      reservation2 = hotel.book_reservation(available_room2, new_booking_dates2)

      expect(available_room2.reservations.length).must_equal 2
      expect(available_room2.reservations[0]).must_equal reservation1
      expect(available_room2.reservations[1]).must_equal reservation2
    end

    it 'new reservation booking dates should be added to rooms unavailable dates' do
      hotel.add_rooms(1,200)
      
      available_room = hotel.find_first_available_room(new_booking_dates)
      hotel.book_reservation(available_room, new_booking_dates)

      expect(available_room.unavailable_dates).must_equal new_booking_dates
    end
  end

  describe 'find_reservations_bydate' do
    let (:input_date)  {
      Date.parse('Apr, 1 2019')
    }

    it 'returns list of reservations on given date' do
        hotel.add_rooms(2,200)
        
        available_room1 = hotel.find_first_available_room(new_booking_dates)
        reservation1 = hotel.book_reservation(available_room1, new_booking_dates)
        
        available_room2 = hotel.find_first_available_room(new_booking_dates)
        reservation2 = hotel.book_reservation(available_room2, new_booking_dates)

        reservations_on_date = hotel.find_reservations_bydate(input_date)
        expect(reservations_on_date.length).must_equal 2
        expect(reservations_on_date).must_include reservation1
        expect(reservations_on_date).must_include reservation2
    end

    it 'returns nil if there are no reservations yet' do
      reservations_on_date = hotel.find_reservations_bydate(input_date)

      expect(reservations_on_date).must_be_nil
    end

    it 'raises error if date input is invalid' do
      expect{hotel.find_reservations_bydate('Apr, 1 2019')}.must_raise ArgumentError
      expect{hotel.find_reservations_bydate(20)}.must_raise ArgumentError
      expect{hotel.find_reservations_bydate(nil)}.must_raise ArgumentError
    end
  end
  
end
