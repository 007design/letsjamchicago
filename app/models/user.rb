class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :events, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :invitations, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
end
