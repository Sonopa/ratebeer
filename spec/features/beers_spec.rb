require 'spec_helper'

describe "Beer" do
  before :each do
    FactoryGirl.create(:brewery, name:"Koff")
    FactoryGirl.create(:user)
    visit signin_path
    fill_in('username', with:'Pekka')
    fill_in('password', with:'Foobar1')
    click_button('Log in')
  end

  it "is created when name is valid" do
    visit new_beer_path

    select('Koff', from: 'beer_brewery_id')
    select('Lager', from: 'beer_style')
    fill_in('beer_name', with: 'Koff')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "is not created when name is not valid" do
    visit new_beer_path

    select('Koff', from: 'beer_brewery_id')
    select('Lager', from: 'beer_style')

    expect(Beer.count).to eq(0)
    expect(current_path).to eq(new_beer_path)

  end
end