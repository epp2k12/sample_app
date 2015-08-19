class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy
	has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
	has_many :following, through: :active_relationships, source: :followed
	
	has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
	has_many :followers, through: :passive_relationships, source: :follower 
	has_many :comments, dependent: :destroy
	attr_accessor :remember_token

	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
	validates :email, presence: true, length: { maximum: 255 },
					  format: { with: VALID_EMAIL_REGEX},
					  uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6}

	# Returns a hash digest of a given string
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
									BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Returns a random token
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	# Remembers a user in the database for use in persistent sessions.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	def authenticated?(remember_token)
		return false if remember_digest.nil? # to avoid errors for users w/o remember_digest and authenticated
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	def forget
		update_attribute( :remember_digest, nil )
	end

	def feed
		# id is an attribute of User model associated in its table id 
		# check that only posts of the current user is shown
		# NOTE: we can only use current user on views
		
		# Micropost.where("user_id = ?", self.id)

		following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
		Micropost.where("user_id IN(#{following_ids}) OR user_id = :user_id", user_id: self.id)
	end

	# Follows a user
	def follow(other_user) 
		active_relationships.create(followed_id: other_user.id)
	end

	# Unfollows a user
	def unfollow(other_user)
		active_relationships.find_by(followed_id: other_user.id).destroy
	end

	# Returns true if the current user is following the other user.
	def following?(other_user)
		following.include?(other_user)
	end

	def hello
		# @user3 = User.find_by(id: 2)
		# following?(@user3)
		self.following.count
	end
 
end
