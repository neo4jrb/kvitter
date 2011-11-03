class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    respond_to do |format|
      format.html do
        query = params[:query]
        @user = User.find_by_twid(query) if query && !query.empty?
        redirect_to @user if @user
      end
      format.json do
        @users = User.all
        nodes = @users.map{|u| {:name => u.twid, :value => u.tweeted.size}}
        links = []
        @users.each do |user|
          links += user.knows.map {|other| { :source => nodes.find_index{|n| n[:name] == user.twid}, :target => nodes.find_index{|n| n[:name] == other.twid}}}
        end
        render :json => {:nodes => nodes, :links => links}
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @knows = @user.knows.paginate(:page => params[:page], :per_page => 10)
    @recommend = recommend(@user)
    @mentioned_from = @user.mentioned_from

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, :notice => 'User was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  private

  def recommend(user)
    my_tags = user.used_tags.to_a
    my_friends = user.knows.to_a
    # find my users tags and all people using those tags, but exclude my friends
    # we are here using the raw java API - that's why using _java_node, raw and wrapper
    friends_friends =  user._java_node.outgoing(:used_tags).incoming(:used_tags).raw.depth(2).filter{|path| path.length == 2 && !my_friends.include?(path.end_node)}
    # for all those people, find the person who has the max number of same tags as I have
    found = friends_friends.max_by{|friend| (friend.outgoing(:used_tags).raw.map{|tag| tag[:name]} & my_tags).size }
    found && found.wrapper # load the ruby wrapper around the neo4j java node
  end
end
