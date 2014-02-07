require 'spec_helper'

describe "User page" do
  let!(:beer) { FactoryGirl.create :beer }
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user, username:"user2") }
  let!(:rating1) { FactoryGirl.create(:rating, beer:beer, user:user1, score:20) }
  let!(:rating2) { FactoryGirl.create(:rating, beer:beer, user:user1, score:30) }
  let!(:rating3) { FactoryGirl.create(:rating, beer:beer, user:user2, score:10) }

  it "shows ratings made by user" do
    visit user_path(user1)

    expect(page).to have_content "anonymous 20"
    expect(page).to have_content "anonymous 30"
  end

  it "does not show other users' ratings" do
    visit user_path(user1)

    expect(page).not_to have_content "anonymous 10"
  end

  it "shows users' favorite beer, brewery and style" do
    visit user_path(user1)

    expect(page).to have_content "Favorite beer style: Lager"
    expect(page).to have_content "Favorite beer: anonymous"
    expect(page).to have_content "Favorite brewery: anonymous"
  end
end