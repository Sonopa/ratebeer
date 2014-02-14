class Beer < ActiveRecord::Base
  include RatingAverage
  validates :name, length: {minimum: 1}
  #validates_presence_of :style
  belongs_to :brewery
  has_many :ratings, :dependent => :destroy
  has_many :raters, -> {uniq}, through: :ratings, source: :user
  belongs_to :style



  def to_s
    name + " Panimo: " + brewery.name
  end
end
