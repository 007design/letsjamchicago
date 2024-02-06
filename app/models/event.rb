class Event < ApplicationRecord
  has_many :attendees, dependent: :destroy
  has_many :invitations, dependent: :destroy
  belongs_to :user, foreign_key: :user_id, class_name: "User", inverse_of: :events

  validates :name, :location, :start_date, presence: true
end
