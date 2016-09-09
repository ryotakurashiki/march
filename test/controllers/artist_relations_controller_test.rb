require 'test_helper'

class ArtistRelationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist_relation = artist_relations(:one)
  end

  test "should get index" do
    get artist_relations_url
    assert_response :success
  end

  test "should get new" do
    get new_artist_relation_url
    assert_response :success
  end

  test "should create artist_relation" do
    assert_difference('ArtistRelation.count') do
      post artist_relations_url, params: { artist_relation: { MediumArtistRelation: @artist_relation.MediumArtistRelation, artist_id: @artist_relation.artist_id, artist_id: @artist_relation.artist_id, g: @artist_relation.g, medium_artist_id: @artist_relation.medium_artist_id, medium_id: @artist_relation.medium_id, related_artist_id: @artist_relation.related_artist_id, scaffold: @artist_relation.scaffold } }
    end

    assert_redirected_to artist_relation_url(ArtistRelation.last)
  end

  test "should show artist_relation" do
    get artist_relation_url(@artist_relation)
    assert_response :success
  end

  test "should get edit" do
    get edit_artist_relation_url(@artist_relation)
    assert_response :success
  end

  test "should update artist_relation" do
    patch artist_relation_url(@artist_relation), params: { artist_relation: { MediumArtistRelation: @artist_relation.MediumArtistRelation, artist_id: @artist_relation.artist_id, artist_id: @artist_relation.artist_id, g: @artist_relation.g, medium_artist_id: @artist_relation.medium_artist_id, medium_id: @artist_relation.medium_id, related_artist_id: @artist_relation.related_artist_id, scaffold: @artist_relation.scaffold } }
    assert_redirected_to artist_relation_url(@artist_relation)
  end

  test "should destroy artist_relation" do
    assert_difference('ArtistRelation.count', -1) do
      delete artist_relation_url(@artist_relation)
    end

    assert_redirected_to artist_relations_url
  end
end
