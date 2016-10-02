class Kana < ApplicationRecord
  belongs_to :artist

  validates :name, format: { without: /\s/ }
end
