require 'spec_helper'

describe "bartenders/new" do
  before(:each) do
    assign(:bartender, stub_model(Bartender,
      :bar => "MyString",
      :user_id => 1,
      :is_working => false
    ).as_new_record)
  end

  it "renders new bartender form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bartenders_path, "post" do
      assert_select "input#bartender_bar[name=?]", "bartender[bar]"
      assert_select "input#bartender_user_id[name=?]", "bartender[user_id]"
      assert_select "input#bartender_is_working[name=?]", "bartender[is_working]"
    end
  end
end
