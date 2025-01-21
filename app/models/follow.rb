class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  enum status: { pending: "pending", accepted: "accepted" }
end
