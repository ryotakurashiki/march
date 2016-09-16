class Ticket < ApplicationRecord
  belongs_to :concert

  scope :last_update_before, -> (start_date = Time.zone.now) { where(arel_table[:updated_at].lt(start_date)) }

  def self.find_or_create_by(params)
    ticket = self.find_by(medium_id: params[:medium_id], medium_ticket_id: params[:medium_ticket_id])
    if ticket
      ticket.update(params)
    else
      ticket = self.create(params)
    end
    ticket
  end
end
