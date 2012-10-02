# -*- encoding : utf-8 -*-
class Tweet < Neo4j::Rails::Model
  property :text, :type => String, :index => :fulltext
  property :link, :type => String
  property :date, :type => DateTime, :index => :exact
  property :tweet_id, :type => String, :index => :exact

  has_n :tags
  has_n :mentions
  has_n :links
  has_one(:tweeted_by).from(:tweeted)


  def to_s
    text.gsub(/(@\w+|https?\S+|#\w+)/,"").strip
  end

  def self.parse(item)
    {:tweet_id => item['id_str'],
     :text => item['text'],
     :date => Time.parse(item['created_at']),
     :link => "http://twitter.com/#{item['from_user']}/statuses/#{item['id_str']}"
    }
  end

end
