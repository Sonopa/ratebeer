class User < ActiveRecord::Base
  include RatingAverage
  has_secure_password
  validates :username, uniqueness: true, length: {minimum: 3, maximum: 15}
  has_many :ratings, :dependent => :destroy
  has_many :beers, through: :ratings
  has_many :memberships, :dependent => :destroy
  has_many :beer_clubs, through: :memberships
  validates :password, format: {:with => /(?=.*)(?=.*[A-Z])(?=.*[0-9]).{4,}/}


  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    best_score = 0
    fav_style = nil
    styles = ratings.group_by{|r| r.beer.style}
    styles.each do |key, array|
      avg = average(array)
      if avg >= best_score
        best_score = avg
        fav_style = key
      end
    end
    fav_style
  end

  def favorite_brewery
    return nil if ratings.empty?
    best_score = 0
    fav_style = nil
    styles = ratings.group_by{|r| r.beer.brewery}
    styles.each do |key, array|
      avg = average(array)
      if avg >= best_score
        best_score = avg
        fav_style = key
      end
    end
    fav_style.name
  end

  def average(ratings)
    c = ratings.collect { |r| r.score }
    s = c.inject {|sum, n| sum + n}
    avg = s/ratings.size
  end

end
