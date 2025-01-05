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

  enum role: { general: 0, admin: 1, owner: 2 }
end
