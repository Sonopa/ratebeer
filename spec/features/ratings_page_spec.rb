require 'spec_helper'

describe "Ratings page" do
  before :each do
    beer = FactoryGirl.create(:beer)
    user = FactoryGirl.create(:user)
    FactoryGirl.create(:rating, beer:beer, user:user, score:20)
    FactoryGirl.create(:rating, beer:beer, user:user, score:30)
  end

  it "shows ratings" do
    visit ratings_path

    expect(page).to have_content "anonymous 20"
    expect(page).to have_content "anonymous 30"
  end

  it "shows number of ratings" do
    visit ratings_path

    expect(page).to have_content "Number of ratings: 2"
  end
end