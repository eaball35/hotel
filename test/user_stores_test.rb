require_relative 'test_helper'
require 'awesome_print'

describe 'user stories' do
    let (:hotel)  {
        ReservationBooker.new
      }
    let (:new_booking_dates)  {
        DateChecker.new('Apr, 1 2019', 'Apr, 4 2019').booking_date_range
      }
    let (:input_date)  {
        Date.parse('Apr, 2 2019')
      }  

    describe 'wave 1' do
        it 'I can access the list of all of the rooms in the hotel' do
            hotel.add_rooms(20,200)
            list_of_room = hotel.rooms

            expect(list_of_room).must_be_instance_of Array
            expect(list_of_room[0]).must_be_instance_of Room
            expect(list_of_room.length).must_equal 20
        end
        it 'I can make a reservation of a room for a given date range' do
            hotel.add_rooms(20,200)

            available_room = hotel.find_first_available_room(new_booking_dates)
            new_reservation = hotel.book_reservation(available_room, new_booking_dates)

            expect(new_reservation).must_be_instance_of Reservation
            expect(new_reservation.room).must_equal available_room
            expect(new_reservation.booking_date_range).must_equal new_booking_dates
            expect(hotel.reservations).must_include new_reservation
            expect(available_room.reservations).must_include new_reservation
        end
        
        it 'I can access the list of reservations for a specific date, so that I can track reservations by date' do
            hotel.add_rooms(3,200)

            available_room1 = hotel.find_first_available_room(new_booking_dates)
            new_reservation1 = hotel.book_reservation(available_room1, new_booking_dates)
            
            available_room2 = hotel.find_first_available_room(new_booking_dates)
            new_reservation2 = hotel.book_reservation(available_room2, new_booking_dates)

            reservations = hotel.find_reservations_bydate(input_date)
 
            expect(reservations).must_be_instance_of Array
            expect(reservations.length).must_equal 2
            expect(reservations).must_include new_reservation1
            expect(reservations).must_include new_reservation2
        end
        
        it 'I can get the total cost for a given reservation' do
            hotel.add_rooms(3,200)

            available_room = hotel.find_first_available_room(new_booking_dates)
            new_reservation = hotel.book_reservation(available_room, new_booking_dates)
            total_cost = hotel.find_totalcost_byreservation(new_reservation)

            expect(total_cost).must_equal 600
        end
        
        it 'I want exception raised when an invalid date range is provided, so that I cant make a reservation for an invalid date range' do
            expect{DateChecker.new(nil, nil)}.must_raise ArgumentError
            expect{DateChecker.new('45', 'date')}.must_raise ArgumentError

            hotel.add_rooms(1,200)
            available_room = hotel.find_first_available_room(new_booking_dates)
            expect{hotel.book_reservation(available_room, 'booking_date_range')}.must_raise ArgumentError
            expect{hotel.book_reservation(available_room, 'Jan 1, 2019')}.must_raise ArgumentError
            expect{hotel.book_reservation(available_room, nil)}.must_raise ArgumentError    
        end
    end
    
    describe 'wave 2' do
    end

end