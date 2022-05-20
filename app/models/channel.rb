class Channel < ApplicationRecord
  has_many :videos, dependent: :destroy
  enum :last_fetch_status, [:no_attempt, :success, :failure]
end
