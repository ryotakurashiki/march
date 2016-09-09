require 'test_helper'

class DeactiveConcertsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deactive_concert = deactive_concerts(:one)
  end

  test "should get index" do
    get deactive_concerts_url
    assert_response :success
  end

  test "should get new" do
    get new_deactive_concert_url
    assert_response :success
  end

  test "should create deactive_concert" do
    assert_difference('DeactiveConcert.count') do
      post deactive_concerts_url, params: { deactive_concert: { active: @deactive_concert.active, category: @deactive_concert.category, date: @deactive_concert.date, date_text: @deactive_concert.date_text, eplus_id: @deactive_concert.eplus_id, integer: @deactive_concert.integer, place: @deactive_concert.place, prefecture_id: @deactive_concert.prefecture_id, title: @deactive_concert.title } }
    end

    assert_redirected_to deactive_concert_url(DeactiveConcert.last)
  end

  test "should show deactive_concert" do
    get deactive_concert_url(@deactive_concert)
    assert_response :success
  end

  test "should get edit" do
    get edit_deactive_concert_url(@deactive_concert)
    assert_response :success
  end

  test "should update deactive_concert" do
    patch deactive_concert_url(@deactive_concert), params: { deactive_concert: { active: @deactive_concert.active, category: @deactive_concert.category, date: @deactive_concert.date, date_text: @deactive_concert.date_text, eplus_id: @deactive_concert.eplus_id, integer: @deactive_concert.integer, place: @deactive_concert.place, prefecture_id: @deactive_concert.prefecture_id, title: @deactive_concert.title } }
    assert_redirected_to deactive_concert_url(@deactive_concert)
  end

  test "should destroy deactive_concert" do
    assert_difference('DeactiveConcert.count', -1) do
      delete deactive_concert_url(@deactive_concert)
    end

    assert_redirected_to deactive_concerts_url
  end
end
