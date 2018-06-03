class SubprojectPhase < ApplicationRecord
  belongs_to :subproject
  belongs_to :phase

  delegate :color, to: :subproject

  validates :subproject, presence: true, uniqueness: { scope: :phase_id }
  validates :phase, presence: true, uniqueness: { scope: :subproject_id }

  def title
    [
      subproject.project_name,
      subproject.name,
      phase.name
    ].join(' / ')
  end
end
