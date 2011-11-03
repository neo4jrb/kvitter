class TagsController < ApplicationController
  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = Tag.find(params[:id])

    @tweets = @tag.tweets.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.json
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @tag }
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, :notice => 'Tag was successfully created.' }
        format.json { render :json => @tag, :status => :created, :location => @tag }
      else
        format.html { render :action => "new" }
        format.json { render :json => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to @tag, :notice => 'Tag was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to tags_url }
      format.json { head :ok }
    end
  end

  def search
    @tag = Tag.find(params[:id])

    search = Twitter::Search.new
    result = search.hashtag(@tag.name)

    curr_page = 0
    while curr_page < 15 do
      result.each do |item|
        parsed_tweet_hash = Tweet.parse(item)
        next if Tweet.find_by_tweet_id(parsed_tweet_hash[:tweet_id])
        tweet = Tweet.create!(parsed_tweet_hash)

        twid = item['from_user'].downcase
        user = User.find_or_create_by(:twid => twid)
        user.tweeted << tweet
        user.save

        parse_tweet(tweet, user)
      end
      result.fetch_next_page
      curr_page += 1
    end

    redirect_to @tag
  end


  def parse_tweet(tweet, user)
    tweet.text.gsub(/(@\w+|https?:\/\/[a-zA-Z0-9\-\.~\:\?#\[\]\!\@\$&,\*+=;,\/]+|#\w+)/).each do |t|
      case t
        when /^@.+/
          t = t[1..-1].downcase
          other = User.find_or_create_by(:twid => t)
          user.knows << other unless t == user.twid || user.knows.include?(other)
          user.save
          tweet.mentions << other
        when /#.+/
          t = t[1..-1].downcase
          tag = Tag.find_or_create_by(:name => t)
          tweet.tags << tag unless tweet.tags.include?(tag)
          user.used_tags << tag unless user.used_tags.include?(tag)
          user.save
        when /https?:.+/
          link = Link.find_or_create_by(:url => t)
          tweet.links << link.redirected_link || link
      end
    end
    tweet.save!
  rescue
  end


end
