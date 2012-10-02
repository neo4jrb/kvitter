# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "tweets/show.html.erb" do
  before(:each) do
    @tweet = assign(:tweet, stub_model(Tweet,
      :text => "Text",
      :link => "Link",
      :tweet_id => "Tweet"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Text/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Link/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Tweet/)
  end
end
