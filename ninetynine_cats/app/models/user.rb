class User < ApplicationRecord
    after_initialize :ensure_session_token
    validates :user_name, :session_token, :password_digest, presence: true
    validates :password, length: { minimum: 6, allow_nil: true}

    attr_reader :password

    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)

        if user && user.is_password?(password)
            user
        else
            nil
        end

    end

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password) #create a BCrypt password object (hash+salt)
        @password = password
    end

    def is_password?(password)
        password_object = BCrypt::Password.new(self.password_digest) #similar to controller's 'new' method that create BCrypt object, not 'created' yet, for testing purpose
        password_object.is_password?(password) #BCrypt method that runs validation
    end
end
