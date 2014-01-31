class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club
  validates_presence_of :user_id
  validates_uniqueness_of :user_id, scope: :beer_club_id

end
