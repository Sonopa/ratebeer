require 'spec_helper'



describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved when password too short" do
    user = User.create username:"Pekka", password:"A2"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved when password has no numbers" do
    user = User.create username:"Pekka", password:"Abcd"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_style).to eq(beer.style.name)
    end

    it "is the one with highest average rating if several rated" do
      create_beer_with_rating_and_style(10, user, "Porter")
      create_beer_with_rating_and_style(30, user, "IPA")
      create_beer_with_rating_and_style(40, user, "IPA")
      create_beer_with_rating_and_style(10, user, "Pale Ale")
      create_beer_with_rating_and_style(20, user, "Pale Ale")

      expect(user.favorite_style).to eq("IPA")
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      brewery = FactoryGirl.create(:brewery)
      beer = FactoryGirl.create(:beer, brewery:brewery)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_brewery).to eq(brewery.name)
    end

    it "is the one with highest average rating if several rated" do
      b1 = FactoryGirl.create(:brewery, name:"test1")
      b2 = FactoryGirl.create(:brewery, name:"test2")
      b3 = FactoryGirl.create(:brewery, name:"test3")
      create_beer_with_rating_and_brewery(10, user, b1)
      create_beer_with_rating_and_brewery(30, user, b2)
      create_beer_with_rating_and_brewery(40, user, b2)
      create_beer_with_rating_and_brewery(50, user, b3)
      create_beer_with_rating_and_brewery(50, user, b3)

      expect(user.favorite_brewery).to eq("test3")
    end
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      rating = Rating.new score:10
      rating2 = Rating.new score:20

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  def create_beer_with_rating(score, user)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings(*scores, user)
    scores.each do |score|
      create_beer_with_rating(score, user)
    end
  end

  def create_beer_with_rating_and_style(score, user, style)
    st = FactoryGirl.create(:style, name:style)
    beer = FactoryGirl.create(:beer, style:st)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beer_with_rating_and_brewery(score, user, brewery)
    beer = FactoryGirl.create(:beer, brewery:brewery)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end


end
