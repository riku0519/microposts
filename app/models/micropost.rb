class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  
  
  has_many :favorite_relationships, class_name:  "Favorite",
                                    foreign_key: "micropost_id",
                                    dependent:   :destroy
  has_many :favorite_users, through: :favorite_relationships, source: :user
  
  def like(user)
    favorite_relationships.find_or_create_by(user_id: user.id)
  end

  def unlike(user)
    favorite_relationship = favorite_relationships.find_by(user_id: user.id)
    favorite_relationship.destroy if favorite_relationship
  end

  def like?(user)
    favorite_users.include?(user)
  end
end