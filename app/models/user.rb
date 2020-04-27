class User < ActiveRecord::Base

	extend FriendlyId
	friendly_id :username, use: :slugged
	
	has_secure_password

	validates :username, :email, :presence => true

	has_many :tweets
end
