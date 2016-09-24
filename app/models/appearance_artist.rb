class AppearanceArtist < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  belongs_to :artist

  def self.create_or_find(params)
    self.create(params) unless self.find_by()
  end

  def setlist_url
    "http://www.livefans.jp" + setlist_path
  end
end
