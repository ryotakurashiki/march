class CrawlStatus < ApplicationRecord
  belongs_to :medium_artist_relation

  scope :eplus, -> {
    includes(:medium_artist_relations).
    where(medium_artist_relations: {medium_id: 1})
  }
end
