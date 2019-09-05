require_relative 'test_helper'

describe 'reservation tests' do
  
  let (:room1)  {
    Room.new(1,200) 
  }
  
  let (:booking_dates1)  {
    DateChecker.new('Jan, 1, 2019', 'Jan 4, 2019').booking_date_range 
  }

  let (:reservation1)  {
    Reservation.new(room1, booking_dates1) 
  }

  it 'should create a new insance of reservation with given room and booking date ranges' do
    expect(reservation1).must_be_instance_of Reservation
    expect(reservation1.room).must_equal room1
    expect(reservation1.booking_date_range).must_equal booking_dates1
  end

  it 'should calculate reservation price using room and dates' do
    expect(reservation1.price).must_equal 600
  end
end