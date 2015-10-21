class User < ActiveRecord::Base
	enum role: [:user, :admin]
	before_create :generate_api_token
  before_create :encrypt_password
  before_save { self.email = email.downcase }
  validates :password, presence: true
  validates :name, presence: true, length: { minimum: 3, maximum: 100 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 105 },
                                    uniqueness: { case_sensitive: false },
                                    format: { with: VALID_EMAIL_REGEX }

  def encrypt_password
  	self.password = Digest::SHA1.base64digest(password)
  end

	def generate_api_token
  	token = SecureRandom.base64.tr('+/=', 'Qrt')
		self.api_token = token
	end

end
