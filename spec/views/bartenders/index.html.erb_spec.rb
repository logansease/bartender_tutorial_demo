require 'spec_helper'

describe "bartenders/index" do
  before(:each) do
    assign(:bartenders, [
      stub_model(Bartender,
        :bar => "Bar",
        :user_id => 1,
        :is_working => false
      ),
      stub_model(Bartender,
        :bar => "Bar",
        :user_id => 1,
        :is_working => false
      )
    ])
  end

  it "renders a list of bartenders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Bar".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
