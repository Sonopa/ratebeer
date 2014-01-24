module RatingAverage
  extend ActiveSupport::Concern
  def average_rating
    c = ratings.collect { |r| r.score }
    s = c.inject {|sum, n| sum + n}
    avg = s/ratings.size
    avg.to_s
  end
end