# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "users/new.html.erb" do
  before(:each) do
    assign(:user, stub_model(User,
      :twid => "MyString",
      :link => "MyString"
    ).as_new_record)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path, :method => "post" do
      assert_select "input#user_twid", :name => "user[twid]"
      assert_select "input#user_link", :name => "user[link]"
    end
  end
end
