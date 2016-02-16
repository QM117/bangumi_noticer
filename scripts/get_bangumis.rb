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
      puts "Bad network"  # TODO: should write to log
    end

    bangumi_list = body.scan(Regexp.new(TIME + CLASSFICATION + TITLE_WITH_TAG + MAGNET_LINK_AND_SIZE))

    bangumi_list.each do |bangumi|
      if (Bangumi.find_by(title: bangumi[4], classfication: bangumi[1])).nil?
        new_bangumi = Bangumi.new(upload_at: bangumi[0], classfication: bangumi[1], fansub: bangumi[3], title: bangumi[4], magnet_link: bangumi[5], size: bangumi[6])

        new_bangumi.save if new_bangumi.valid?
      end
    end

  end
end
