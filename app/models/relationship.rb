# == Schema Information
#
# Table name: relationships
#
#  id                :integer          not null, primary key
#  relationship_type :string(255)
#  follower_id       :integer
#  followed_id       :integer
#  is_unsubscribed   :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Relationship < ActiveRecord::Base
  attr_accessible :followed_id, :follower_id, :relationship_type

  validates_uniqueness_of :followed_id, :scope => [:follower_id, :relationship_type]
  validates :follower_id, :presence => true
  validates :followed_id, :presence => true

  belongs_to :follower, :foreign_key => "follower_id", :class_name => "User"

  belongs_to :followed_bartenders, -> {where(relationships: { relationship_type: RELATIONSHIP_TYPE_BARTENDER })}, :foreign_key => "followed_id", :class_name => "Bartender"

  def target
    if relationship_type == RELATIONSHIP_TYPE_BARTENDER
      Bartender.find(followed_id)
    end
  end


end
