require 'phantomjs'

module Crawler::Camp
  class ScrapeTicket < Crawler::MechanizeBase
    def initialize
      super
      @logger = Logger.new(Rails.root.join('log', 'camp.log'))
      @logger.level = Logger::INFO
      @logger.warn "=> Booting TicketCamp Crawler..."
      @base_url = 'https://ticketcamp.net'
    end

    def run
      MediumArtistRelation.camp.crawlable(3).each do |medium_artist_relation| #.reverse .shuffle
      #MediumArtistRelation.where(medium_artist_id: ["t-second-tickets", "100"], medium_id: 2).each do |medium_artist_relation|
        ActiveRecord::Base.connection_pool.with_connection do
          start_date = Time.zone.now
          artist = medium_artist_relation.artist
          crawl_status = medium_artist_relation.crawl_status
          crawl_status.error_count = 0
          url = medium_artist_relation.camp_url
          puts "次のアーティスト #{artist.name}"

          loop do
            puts "↓次見に行くページ↓"
            puts url
            @logger.info "visit #{url}"

            sleep(3)
            page = @agent.get(url)

            #セトリURL（出演情報)の取得
            doc = Nokogiri::HTML.parse(page.content.toutf8)
            rows = doc.css('section.module-list-ticket div.content ul li ul.row')

            rows.each do |row|
              row.css('a').inner_text
              concert_a = row.at('li[2] a')
              ticket_path = concert_a.get_attribute(:href).match(/ticketcamp.net\/(.*)/)[1]
              medium_ticket_id = ticket_path.match(/[0-9]+\/$/).to_s.chop
              ticket =  Ticket.find_by(medium_id: 2, medium_ticket_id: medium_ticket_id)
              if ticket
                next if ticket.updated_at >= 6.hours.ago # 6時間以内に更新済みであればスキップ
              end

              date_text = row.at('li[3] a').inner_text[/\/(.*)\(/,1]
              date = Date.parse(date_text)
              if concert = artist.concerts.find_by(date: date)
                puts "not new concert"
              else
                puts "new concert"
                next
              end

              place = strip_delete(row.at('li[4] a').inner_text)
              prefecture = place.match(/\(.?.?.?.?\)$/).to_s.delete("()")

              concert_name = strip_delete(concert_a.inner_text)
              seat = strip_delete(row.at('li[5] a p').inner_text)
                .gsub(/.*【座席・席種】|【ご案内】|【発送方法】/,"").strip.slice(0..55)

              number_of_tickets = strip_delete(row.at('li[6] a p span[1]').inner_text)
              selling_separately = number_of_tickets.match(/〜/) ? true : false
              price = row.at('li[6] a span.ticket-price').inner_text.delete(',').to_i
              extra_payment_text = row.at('li[6]').inner_text
              extra_payment = extra_payment_text.match(/チケット代別途/)? true : false

              ticket = concert.tickets.find_by(medium_id: 2, medium_ticket_id: medium_ticket_id)
              params = {
                concert_id: concert.id, ticket_path: ticket_path, medium_id: 2, medium_ticket_id: medium_ticket_id,
                seat: seat, number_of_tickets: number_of_tickets, price: price, extra_payment: extra_payment,
                selling_separately: selling_separately
              }
              puts params
              update_or_create_ticket(ticket, params)

              puts concert_name
              puts ticket_path
              puts medium_ticket_id
              puts date
              puts place
              puts prefecture
              puts seat
              puts number_of_tickets
              puts selling_separately
              puts price
              puts extra_payment
              puts ""
            end

            nolinkflag = 1
            doc.css("div.pagination ul li.next a").each do |a|
              nolinkflag = 0
              url =  a.get_attribute(:href)
            end
            if nolinkflag == 1 then
              break
            end
            #break
          end
          # 更新されていないもの（消えたチケット）は全消し
          artist.concerts.map{ |concert| concert.tickets.last_update_before(start_date).delete_all }
        end
      end
    end

    private

    def strip_delete(text)
      text.strip.delete("\n").gsub(/([\t| |　]+)/," ")
    end

  end
end