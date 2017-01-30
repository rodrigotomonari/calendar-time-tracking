class NotifyMessage < ApplicationRecord
  validates :message, presence: true
end
