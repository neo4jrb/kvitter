# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "tweets/new.html.erb" do
  before(:each) do
    assign(:tweet, stub_model(Tweet,
      :text => "MyString",
      :link => "MyString",
      :tweet_id => "MyString"
    ).as_new_record)
  end

  it "renders new tweet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tweets_path, :method => "post" do
      assert_select "input#tweet_text", :name => "tweet[text]"
      assert_select "input#tweet_link", :name => "tweet[link]"
      assert_select "input#tweet_tweet_id", :name => "tweet[tweet_id]"
    end
  end
end
