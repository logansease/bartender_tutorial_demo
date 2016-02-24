require 'spec_helper'

describe "bartenders/show" do
  before(:each) do
    @bartender = assign(:bartender, stub_model(Bartender,
      :bar => "Bar",
      :user_id => 1,
      :is_working => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Bar/)
    rendered.should match(/1/)
    rendered.should match(/false/)
  end
end
