class Tweet < Neo4j::Rails::Model
  property :text, :type => String
  property :link, :type => String
  property :date, :type => DateTime
  property :tweet_id, :type => String

  index :tweet_id

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
