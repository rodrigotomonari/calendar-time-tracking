class SubprojectPhase < ApplicationRecord
  belongs_to :subproject
  belongs_to :phase

  validates :subproject, presence: true, uniqueness: { scope: :phase_id }
  validates :phase, presence: true, uniqueness: { scope: :subproject_id }

  def title
    [
      subproject.project.name,
      subproject.name,
      phase.name
    ].join(' / ')
  end

  def color
    subproject.project.color
  end
end
