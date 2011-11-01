require "spec_helper"

describe TweetsController do
  describe "routing" do

    it "routes to #index" do
      get("/tweets").should route_to("tweets#index")
    end

    it "routes to #new" do
      get("/tweets/new").should route_to("tweets#new")
    end

    it "routes to #show" do
      get("/tweets/1").should route_to("tweets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tweets/1/edit").should route_to("tweets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tweets").should route_to("tweets#create")
    end

    it "routes to #update" do
      put("/tweets/1").should route_to("tweets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tweets/1").should route_to("tweets#destroy", :id => "1")
    end

  end
end
