class Link < Neo4j::Rails::Model
  property :url, :type => String
  index :url
  has_n(:tweets).from(:links)
  has_one(:redirected_link)
  has_n(:short_urls).from(:redirected_link)

  rule(:real) { redirected_link.nil?}

  before_save :create_redirect_link

  def to_s
    url
  end

  def create_redirect_link
    return unless url =~ /http:\/\/t.co/ || url =~ /http:\/\/bit.ly/
    puts "create_redirect_link '#{url}'"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = 200
    req = Net::HTTP::Head.new(uri.request_uri)
    res = http.request(req)
    redirect = res['location']
    if redirect && url != redirect
      puts "  redirect #{redirect}"
      self.redirected_link = Link.find_or_create_by(:url => redirect.strip)
    end
  rescue Timeout::Error
    puts "Can't acccess #{url}"
  rescue Error
    puts "Can't call #{url}"
  end

end
