# -*- encoding : utf-8 -*-
class User < Neo4j::Rails::Model
  property :twid, :type => String, :index => :exact
  property :link, :type => String

  has_n :tweeted
  has_n :follows
  has_n :knows
  has_n :used_tags
  has_n(:mentioned_from).from(:mentions)

  def to_s
    twid
  end
end
