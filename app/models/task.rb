class Task < ApplicationRecord
  belongs_to :user
  belongs_to :subproject_phase

  validates :user, presence: true
  validates :subproject_phase, presence: true

  def title
    subproject_phase.title
  end
end
