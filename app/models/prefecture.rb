class Prefecture < ApplicationRecord
  has_many :concerts
  has_many :favorite_prefectures
  has_many :users, through: :favorite_prefectures
end
