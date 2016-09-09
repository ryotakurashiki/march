require 'test_helper'

class AppearanceArtistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @appearance_artist = appearance_artists(:one)
  end

  test "should get index" do
    get appearance_artists_url
    assert_response :success
  end

  test "should get new" do
    get new_appearance_artist_url
    assert_response :success
  end

  test "should create appearance_artist" do
    assert_difference('AppearanceArtist.count') do
      post appearance_artists_url, params: { appearance_artist: { artist_id: @appearance_artist.artist_id, concert_id: @appearance_artist.concert_id } }
    end

    assert_redirected_to appearance_artist_url(AppearanceArtist.last)
  end

  test "should show appearance_artist" do
    get appearance_artist_url(@appearance_artist)
    assert_response :success
  end

  test "should get edit" do
    get edit_appearance_artist_url(@appearance_artist)
    assert_response :success
  end

  test "should update appearance_artist" do
    patch appearance_artist_url(@appearance_artist), params: { appearance_artist: { artist_id: @appearance_artist.artist_id, concert_id: @appearance_artist.concert_id } }
    assert_redirected_to appearance_artist_url(@appearance_artist)
  end

  test "should destroy appearance_artist" do
    assert_difference('AppearanceArtist.count', -1) do
      delete appearance_artist_url(@appearance_artist)
    end

    assert_redirected_to appearance_artists_url
  end
end
