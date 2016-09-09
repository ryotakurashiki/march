require 'test_helper'

class MediumArtistRelationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @medium_artist_relation = medium_artist_relations(:one)
  end

  test "should get index" do
    get medium_artist_relations_url
    assert_response :success
  end

  test "should get new" do
    get new_medium_artist_relation_url
    assert_response :success
  end

  test "should create medium_artist_relation" do
    assert_difference('MediumArtistRelation.count') do
      post medium_artist_relations_url, params: { medium_artist_relation: { artist_id: @medium_artist_relation.artist_id, medium_artist_id: @medium_artist_relation.medium_artist_id, medium_id: @medium_artist_relation.medium_id } }
    end

    assert_redirected_to medium_artist_relation_url(MediumArtistRelation.last)
  end

  test "should show medium_artist_relation" do
    get medium_artist_relation_url(@medium_artist_relation)
    assert_response :success
  end

  test "should get edit" do
    get edit_medium_artist_relation_url(@medium_artist_relation)
    assert_response :success
  end

  test "should update medium_artist_relation" do
    patch medium_artist_relation_url(@medium_artist_relation), params: { medium_artist_relation: { artist_id: @medium_artist_relation.artist_id, medium_artist_id: @medium_artist_relation.medium_artist_id, medium_id: @medium_artist_relation.medium_id } }
    assert_redirected_to medium_artist_relation_url(@medium_artist_relation)
  end

  test "should destroy medium_artist_relation" do
    assert_difference('MediumArtistRelation.count', -1) do
      delete medium_artist_relation_url(@medium_artist_relation)
    end

    assert_redirected_to medium_artist_relations_url
  end
end
