# encoding: utf-8
require 'open-uri'

class Api::V1::NoticerController < Api::V1::BaseApiController
  before_action :restrict_access

  URI = 'https://share.dmhy.org'
  TIME = %q{<td.*>\s*.+<span.*>(.*)</span></td>\s+}
  CLASSFICATION = %q{<td.*>\s+<a[^>]+>\s+(?:<b>)?<font.+>(\S+)</font>(?:</b>)?</a>\s+</td>\s+}
  TITLE_WITH_TAG = %q{<td class="title">\s+(?:<span class="tag">\s+<a  href=[^_]+_id/(\d+).+\s+(\S+?)</a></span>)?\s+<a[^>]+>\s+(.+)</a>\s+.*?</td>\s+}
  MAGNET_LINK_AND_SIZE = %q{<td nowrap="nowrap" align="center"><a class="download-arrow arrow-magnet" [^h]+href="(.*)">&nbsp;</a></td>\s+<td nowrap="nowrap" align="center">(\S+)<\/td>}

  def index
    if params[:name].nil? || params[:email].nil?
      render status: 400, json: {error: "Bad request! The params 'name' or 'email' is missing."} and return
    end

    if File.exist?("#{Rails.root}/public/share.dmhy.org")
      html_response = File.read("#{Rails.root}/public/share.dmhy.org")
      bangumi_list = html_response.scan(Regexp.new(TIME + CLASSFICATION + TITLE_WITH_TAG + MAGNET_LINK_AND_SIZE))

      # TODO: should save data in the database
      result = bangumi_list.select{|bangumi| @current_user.subscribe?(bangumi[4])}.map{|bangumi| {title: bangumi[4], magnet_link: bangumi[5]}}

      render status: 200, json: result and return
    else
      render status: 500, json: {error: "There is an error in the server. The website snapshot is missing"} and return
    end
  end
end
