class User < ApplicationRecord
    before_save { self.email.downcase! }
    validates :name, presence: true, length:{ maximum: 50 }
    validates :email, presence: true, length:{ maximum: 255 },
                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                      uniqueness: { case_sensitive: false }
    has_secure_password

    has_many :microposts
    has_many :favorites

    has_many :fav_posts, through: :favorites, source: :micropost
    
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
end
