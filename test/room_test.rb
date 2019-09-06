require_relative 'test_helper'

describe 'room tests' do
  
  let (:room)  {
    Room.new(200) 
  }
  
  it 'should create new instance of room with given cost' do
    expect(room).must_be_instance_of Room
    expect(room.cost).must_equal 200
  end

  it 'should raise error if cost input is invalid'do
  expect{Room.new('200')}.must_raise ArgumentError
  expect{Room.new()}.must_raise ArgumentError
  end
end