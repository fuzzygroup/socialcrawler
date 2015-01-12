require "socialcrawler/version"
require "csv"
require "open-uri"
require "nokogiri"
require 'logger'

# Copyright (C) 2015 Ivica Ceraj
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

module SocialCrawler


  def self._put( hash, symbol , value , log=nil)
    log = Logger.new(STDOUT) if log.nil?
    if not hash.has_key?( symbol)
      hash[symbol] = value
    else
      hash[symbol] = "#{hash[symbol]} #{value}"
      log.info( "Multiple values for #{symbol} value #{hash[symbol]}")
    end
  end

  def self.crawl_url(url,log=nil)
    log = Logger.new(STDOUT) if log.nil?
    log.info( "Crawling #{url}")
    result = Hash.new('NOT FOUND')
    begin
      page = Nokogiri::HTML(open(url))
      title = page.css('title')
      if not title.nil?
        result[:title] = title.text.strip
      end
      links = page.css('a[href]')
      links.each do |link|
        link_url = link['href']

        if not link_url.index('twitter.com/').nil?
          log.info( "twitter #{link_url} for #{url}")
          _put(result,:twitter,link_url,log)
        end
        if not link_url.index('facebook.com/').nil?
          log.info( "facebook #{link_url} for #{url}")
          _put(result,:facebook,link_url,log)
        end
        if not link_url.index('plus.google.com/').nil?
          log.info( "google_plus #{link_url} for #{url}")
          _put(result,:google_plus,link_url,log)
        end
      end
      result[:url] = url
      result[:success] = true
      result[:message] = ''
    rescue Exception => e
      result[:url] = url
      result[:success] = false
      result[:message] = "#{e}"
    end
    return result
  end

  def self.crawl( domain_list_filename, output_list_filename, status_filename=nil , log=nil)
    log = Logger.new(STDOUT) if log.nil?
    log.info( "Crawler started")
    status = Hash.new
    if not status_filename.nil? and File.exists?(status_filename)
      log.info( "Loading previous status from #{status_filename}")
      CSV.foreach( status_filename ) do |row|
        begin
        url = row[0]
        result = row[1]
        message = row[2]
        status[url] = {
            :url => url,
            :result => result,
            :message => message
        }
        rescue Exception => e
          log.info("Exception reading file #{e}")
        end
      end
      log.info( "Loading previous status from #{status_filename} finished, #{status.keys.length} loaded.")
    end

    data = Hash.new()
    if File.exist?(output_list_filename)
      log.info( "Loading previous status from #{output_list_filename}")
      CSV.open( output_list_filename ) do |row|
          if row.count >= 5
            url = row[0]
            title= row[1]
            twitter = row[2]
            facebook = row[3]
            google_plus = row[4]
            data[url] = {
                :url => url,
                :title => title,
                :twitter => twitter,
                :facebook => facebook,
                :google_plus => google_plus
            }
            end
      end
      log.info( "Loading previous status from #{output_list_filename} finished, #{data.keys.length} loaded.")
    end

      CSV.foreach( domain_list_filename ) do |row|
        url = row[0]
        if status.has_key?(url)
          # already visited, skip
        else
          result = crawl_url(url,log)
          if result[:success] == true
            CSV.open( output_list_filename, "wb") do |output|
              data.each do |k,v|
                log.info(k)
                log.info(v)
                  output << [k,v[:title],v[:twitter],v[:facebook],v[:google_plus]]
              end
              output << [url, result[:title], result[:twitter], result[:facebook], result[:google_plus]]
              data[url] = result
            end
            status[url] = {
                :url => url,
                :result => 'success',
                :message => ''
            }
            CSV.open( status_filename, "wb" ) do |status_line|
              status_line << [url,'success','']
            end
          else
            status[url] = {
                :url => url,
                :result => result[:success],
                :message => result[:message]
            }
            CSV.open( status_filename, "wb" ) do |status_line|
              status_line << [url,result[:success],result[:message]]
            end
        end
      end
    end
  end
end

if __FILE__ == $0
  SocialCrawler.crawl(ARGV[0],ARGV[1],ARGV[2])
end