class Video < ApplicationRecord
  include Turbo::Broadcastable
  belongs_to :channel
  enum :status, [:unseen, :seen, :saved]
  after_destroy_commit -> { broadcast_remove_to :videos }
end
