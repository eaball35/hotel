require_relative 'test_helper'

describe 'room tests' do
  it 'should create new instance of room with given roomnumber and cost' do
    roomtest = Room.new(1,200)
    room_number = roomtest.room_number
    room_cost =  roomtest.cost
    
    expect(roomtest).must_be_instance_of Room
    expect(room_number).must_equal 1
    expect(room_cost).must_equal 200
  end

  it 'should raise error if room number is invalid' do
    expect{Room.new("45",200)}.must_raise ArgumentError
    expect{Room.new(nil,200)}.must_raise ArgumentError
    expect{Room.new([],200)}.must_raise ArgumentError
  end
  
end