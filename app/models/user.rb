class User < ApplicationRecord
    before_save { self.email.downcase! }
    validates :name, presence: true, length:{ maximum: 50 }
    validates :email, presence: true, length:{ maximum: 255 },
                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                      uniqueness: { case_sensitive: false }
    has_secure_password

    has_many :microposts
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "follow_id"
    has_many :followers, through: :reverse_of_relationships, source: :user
    has_many :favorites

    has_many :fav_posts, through: :favorites, source: :micropost
    
    def follow(other_user)
        unless self == other_user
            self.relationships.find_or_create_by(follow_id: other_user.id)
        end
    end
    
    def unfollow(other_user)
        rel = self.relationships.find_by(follow_id: other_user.id)
        rel.destroy if rel
    end
    
    def following?(other_user)
        self.followings.include?(other_user)
    end
    
    def add_fav(post)
        self.favorites.find_or_create_by(micropost_id: post.id)
    end
    
    def del_fav(post)
        fav = self.favorites.find_by(micropost_id: post.id)
        fav.destroy if fav
    end
    
    def favorited?(post)
        return self.fav_posts.include?(post)
    end
    
    def list_favorites
        return Micropost.where(id: self.fav_post_ids)
    end
    
    def feed_microposts
        Micropost.where(user_id: self.following_ids + [self.id])
    end
end
