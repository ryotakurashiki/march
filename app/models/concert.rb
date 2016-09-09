class Concert < ApplicationRecord
  has_many :appearance_aritsts
  has_many :artists, through: :appearance_aritsts
  belongs_to :prefecture

end
