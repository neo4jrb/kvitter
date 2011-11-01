require 'spec_helper'

describe "links/edit.html.erb" do
  before(:each) do
    @link = assign(:link, stub_model(Link,
      :url => "MyString"
    ))
  end

  it "renders the edit link form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => links_path(@link), :method => "post" do
      assert_select "input#link_url", :name => "link[url]"
    end
  end
end
