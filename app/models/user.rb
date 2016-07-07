class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :profile, length: { maximum: 50 }
  validates :birthplace, length: { maximum: 10 }
  has_secure_password
  has_many :microposts
  
  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower
  
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  
  has_many :favorite_relationships, class_name:  "Favorite",
                                     foreign_key: "user_id",
                                     dependent:   :destroy
  has_many :favorite_microposts, through: :favorite_relationships, source: :micropost
  
  
  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end
  
  def like(micropost)
    favorite_relationships.find_or_create_by(micropost_id: micropost.id)
  end

  def unlike(micropost)
    favorite_relationship = favorite_relationships.find_by(micropost_id: micropost.id)
    favorite_relationship.destroy if favorite_relationship
  end

  def like?(micropost)
    favorite_microposts.include?(micropost)
  end
  
  def feed_items
    Micropost.where(user_id: following_user_ids + [self.id])
  end
  
end
