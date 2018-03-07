class Task < ApplicationRecord
  belongs_to :user
  belongs_to :subproject_phase

  validates :user, presence: true
  validates :subproject_phase, presence: true
  validates :started_at, presence: true
  validates :ended_at, presence: true

  before_save :set_time

  def title
    subproject_phase.title
  end

  private

  def set_time
    self.time = ended_at - started_at
  end
end
