class User < ActiveRecord::Base
	 has_many :comments

    has_many :article, through: :comments

    attr_accessor :password
    before_save :add_salt_and_hash

    include Humanizer
    require_human_on :create

	validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, on: :create,
    length: { minimum: 5 },
    confirmation: true

    def add_salt_and_hash
        unless password.blank?
            self.password_salt = BCrypt::Engine.generate_salt
            self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
        end
    end

    before_create :add_activation_token
    def add_activation_token
        self.activation_token = SecureRandom.urlsafe_base64
        self.activation_status = "not activated"
    end

end
