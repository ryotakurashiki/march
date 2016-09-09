json.extract! artist, :id, :name, :category, :created_at, :updated_at
json.url artist_url(artist, format: :json)