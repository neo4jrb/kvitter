# -*- encoding : utf-8 -*-
class Link < Neo4j::Rails::Model
  property :url, :type => String, :index =>:exact
  has_n(:tweets).from(:links)
  has_one(:redirected_link)
  has_n(:short_urls).from(:redirected_link)

  SHORT_URLS = %w[t.co bit.ly ow.ly goo.gl tiny.cc tinyurl.com doiop.com readthisurl.com memurl.com tr.im cli.gs short.ie kl.am idek.net short.ie is.gd hex.io asterl.in j.mp] .to_set

  rule(:real) { redirected_link.nil?}

  before_save :create_redirect_link

  def to_s
    url
  end

  private

  def self.short_url?(url)
    domain = url.split('/')[2]
    domain && SHORT_URLS.include?(domain)
  end

  def create_redirect_link
    return if !self.class.short_url?(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = 200
    req = Net::HTTP::Head.new(uri.request_uri)
    res = http.request(req)
    redirect = res['location']
    if redirect && url != redirect
      self.redirected_link = Link.find_or_create_by(:url => redirect.strip)
    end
  rescue Timeout::Error
    puts "Can't acccess #{url}"
  rescue Error
    puts "Can't call #{url}"
  rescue Net::HTTPBadResponse
    puts "Bad response for #{url}"
  end


end
