# encoding: utf-8
require 'open-uri'

class GetBangumis
  DMHY_URL = 'https://share.dmhy.org/'
  TIME = %q{<td.*>\s*.+<span.*>(.*)</span></td>\s+}
  CLASSFICATION = %q{<td.*>\s+<a[^>]+>\s+(?:<b>)?<font.+>(\S+)</font>(?:</b>)?</a>\s+</td>\s+}
  TITLE_WITH_TAG = %q{<td class="title">\s+(?:<span class="tag">\s+<a  href=[^_]+_id/(\d+).+\s+(\S+?)</a></span>)?\s+<a[^>]+>\s+(.+)</a>\s+.*?</td>\s+}
  MAGNET_LINK_AND_SIZE = %q{<td nowrap="nowrap" align="center"><a class="download-arrow arrow-magnet" [^h]+href="(.*)">&nbsp;</a></td>\s+<td nowrap="nowrap" align="center">(\S+)<\/td>}

  def self.start
    begin
      body = open(DMHY_URL).read
    rescue
      Rails.logger.tagged("GET BANGUMIS") {Rails.logger.warn "Bad network"} and return
    end

    Rails.logger.tagged("GET BANGUMIS") {Rails.logger.info "Start getting updates of bangumis"}

    bangumi_list = body.scan(Regexp.new(TIME + CLASSFICATION + TITLE_WITH_TAG + MAGNET_LINK_AND_SIZE))

    exist_bangumis = 0
    bangumi_list.each do |bangumi|
      if Bangumi.exists?(title: bangumi[4], classfication: bangumi[1])
        exist_bangumis += 1
      else
        exist_bangumis = 0
        new_bangumi = Bangumi.new(upload_at: bangumi[0], classfication: bangumi[1], fansub: bangumi[3], title: bangumi[4], magnet_link: bangumi[5], size: bangumi[6])

        if new_bangumi.save
          Subscription.all.each do |subscription|
            subscription.bangumis << new_bangumi if subscription.match? new_bangumi
          end
        else
          Rails.logger.tagged("GET BANGUMIS") {Rails.logger.warn "Something wrong with saving a new bangumi"} and return
        end
      end
      if exist_bangumis == 5
        break
      end
    end
    Rails.logger.tagged("GET BANGUMIS") {Rails.logger.info "Success getting updates of bangumis"}
  end
end
