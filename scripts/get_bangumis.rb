# encoding: utf-8
require 'open-uri'

class GetBangumis
  def self.start
    begin
      body = open("https://www.dmhy.org").read
    rescue
      puts "Bad network"  # TODO: should write to log
    end

    file = File.open("#{Rails.root}/public/share.dmhy.org", 'w')
    file << body
    file.close
  end
end
