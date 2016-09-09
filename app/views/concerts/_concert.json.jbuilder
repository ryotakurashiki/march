json.extract! concert, :id, :title, :place, :prefecture_id, :date, :eplus_id, :created_at, :updated_at
json.url concert_url(concert, format: :json)