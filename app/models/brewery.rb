class Brewery < ActiveRecord::Base
  include RatingAverage
  validates :name, length: {minimum: 1}
  validates :year, numericality: {greater_than_or_equal_to: 1042, only_integer: true}
  validate :year_must_not_be_greater_than_current
	has_many :beers, :dependent => :destroy
  has_many :ratings, :through => :beers

  def print_report
    puts name
    puts "Established in #{year}"
    puts "number of beers #{beers.count}"
    puts "number of ratings #{retings.count}"
  end

  def restart
    self.year = 2014
    puts "changed year to #{year}"
  end

  def year_must_not_be_greater_than_current
    if self.year > Date.today.year
      errors.add(:year, " must be less than current year")
    end
  end
end
