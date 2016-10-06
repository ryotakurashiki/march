require 'phantomjs'
require 'csv'

module Crawler
  class MechanizeBase
    def initialize(use_proxy = true)
      #create_agent
    end

    protected

    def sleep_before_visit
      hour = Time.zone.now.hour
      if hour >= 1 && hour <= 6
        sleep(0.3)
      else
        sleep(20)
      end
    end

    def update_or_create_ticket(ticket, params)
      if ticket
        puts "updated ticket"
        ticket.update(params)
      else
        puts "created ticket"
        Ticket.create(params)
      end
    end

    def js_finish?(session)
      session.evaluate_script('jQuery.active').zero?
    end

    #private

    def create_agent
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.keep_alive = false
      agent.open_timeout = 120
      agent.read_timeout = 180
      agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
      agent
    end
	end
end