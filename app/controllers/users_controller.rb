class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json do
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

  def recommend
    @user = User.find(params[:id])
    my_tags = @user.used_tags.to_a

    # find other users using these tags
    other_people_tags = @user._java_node.outgoing(:knows).incoming(:knows).outgoing(:used_tags).depth(5).filter{|path| path.lastRelationship.rel_type == 'used_tags'}
  end
end
