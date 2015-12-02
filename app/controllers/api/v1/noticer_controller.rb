# encoding: utf-8
require 'open-uri'

class Api::V1::NoticerController < ActionController::Base
  URI = 'https://share.dmhy.org'
  LINE_EXPRESS = /<td class="title">[\s\S]*?<\/td>[\s\S]*?<td nowrap="nowrap" align="center">[\s\S]*?<\/td>/
  MAGNET_EXPRESS = /href="(magnet:.*?)"/
  NAME_EXPRESS = /<td class="title">[\s\S]*?<a href=".*?"  target="_blank" >[\n\s]*(.*?)<\/a>[\s\S]*?<\/td>/

  def index
    # TODO: get User from DB via user log in the system
    user = User.find(1)           # should be replaced

    if File.exist?("#{Rails.root}/public/share.dmhy.org")
      html_response = File.read("#{Rails.root}/public/share.dmhy.org")
      bangumi_list = html_response.scan(LINE_EXPRESS)
      magnet_links = {}

      bangumi_list.each do |bangumi|
        name = bangumi.match(NAME_EXPRESS)[1]
        if user.subscribe?(name)
          magnet_links[name] = bangumi.match(MAGNET_EXPRESS)[1]
        end
      end

      result = []
      magnet_links.each do |title, magnet_link|
        result << {title: title , magent_link: magnet_link}
      end

      render status: 200, json: result and return
    else
      render status: 500, json: {err: "There is an error in the server. The website snapshot is missing"} and return
    end
  end
end