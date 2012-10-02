# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "tweets/index.html.erb" do
  before(:each) do
    assign(:tweets, [
      stub_model(Tweet,
        :text => "Text",
        :link => "Link",
        :tweet_id => "Tweet"
      ),
      stub_model(Tweet,
        :text => "Text",
        :link => "Link",
        :tweet_id => "Tweet"
      )
    ])
  end

  it "renders a list of tweets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Link".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Tweet".to_s, :count => 2
  end
end
