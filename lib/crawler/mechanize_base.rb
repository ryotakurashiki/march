require 'phantomjs'
require 'csv'

module Crawler
  class MechanizeBase
    def initialize
      @logger = Logger.new(Rails.root.join('log', 'crawler.log'))
      @logger.level = Logger::INFO
      @logger.warn "=> Booting EplusCrawler..."
      create_agent
    end

    protected

    def js_finish?(session)
      session.evaluate_script('jQuery.active').zero?
    end

    private

    def create_agent
      @agent = Mechanize.new
      @agent.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X)"
      @agent.keep_alive = false
      @agent.open_timeout = 120
      @agent.read_timeout = 180
      @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @agent
    end
	end
end