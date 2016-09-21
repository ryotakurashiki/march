class TicketsController < ApplicationController
  before_action :set_concert, only: [:show]
  before_action :set_tickets, only: [:show]

  # GET /concerts/1
  # GET /concerts/1.json
  def show
    @tickets = Ticket.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_concert
      @concert = Concert.find(params[:concert_id])
    end

    def set_tickets
      #@concert = Concert.find(params[:id])
      @tickets = @concert.tickets
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit()
    end
end
