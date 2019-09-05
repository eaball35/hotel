require_relative 'test_helper'

describe 'room tests' do
  
  let (:room1)  {
    Room.new(1,200) 
  }
  
  it 'should create new instance of room with given roomnumber and cost' do
    expect(room1).must_be_instance_of Room
    expect(room1.room_number).must_equal 1
    expect(room1.cost).must_equal 200
  end

  it 'should raise error if room number is invalid' do
    expect{Room.new("45",200)}.must_raise ArgumentError
    expect{Room.new(nil,200)}.must_raise ArgumentError
    expect{Room.new([],200)}.must_raise ArgumentError
  end
  
end