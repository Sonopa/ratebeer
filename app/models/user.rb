class User < ActiveRecord::Base
  include RatingAverage
  has_secure_password
  validates :username, uniqueness: true, length: {minimum: 3, maximum: 15}
  has_many :ratings, :dependent => :destroy
  has_many :beers, through: :ratings
  has_many :memberships, :dependent => :destroy
  has_many :beer_clubs, through: :memberships
  validates :password, format: {:with => /(?=.*)(?=.*[A-Z])(?=.*[0-9]).{4,}/}


end
