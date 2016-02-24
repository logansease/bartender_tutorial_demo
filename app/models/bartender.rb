class Bartender < ActiveRecord::Base

  attr_accessible :bar, :is_working, :user_id, :background
  belongs_to :user

  validates :user_id, :presence => true
  validates :bar, :length => { :within => 4..30 }

  mount_uploader :background, ImageUploader

  has_many :bartender_reverse_relationships, -> { where relationship_type: RELATIONSHIP_TYPE_BARTENDER }, :dependent => :destroy,
           :foreign_key => "followed_id",
           :class_name => "Relationship"
  has_many :followers, :through => :bartender_reverse_relationships, :source => :follower

  scope :top_bartenders, -> (limit) { select("count(relationships.id) as followers, bartenders.*")
  .joins("LEFT JOIN relationships ON relationships.followed_id = bartenders.id")
  .order("followers desc").group("relationships.id, bartenders.id")
  .limit(limit)}

  def follower_count
    followers.count
  end

end
