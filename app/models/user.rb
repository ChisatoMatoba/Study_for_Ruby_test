class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :quiz_results, dependent: :destroy
  has_many :memos, dependent: :destroy

  validates :name,                presence: true
  validates :email,               presence: true
  validates :encrypted_password,  presence: true
  validates :role,                presence: true

  validate :validate_email_domain

  enum role: { general: 0, admin: 1, owner: 2 }

  private

  def validate_email_domain
    return if email.blank?

    allowed_domain = ENV['ALLOWED_EMAIL_DOMAIN']
    return if email.end_with?(allowed_domain)

    errors.add(:email, 'は会社メールである必要があります')
  end
end
