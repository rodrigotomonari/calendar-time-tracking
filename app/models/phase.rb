class Phase < ApplicationRecord
  has_many :subproject_phases
  has_many :subprojects, through: :subproject_phases

  validates :name, presence: true, uniqueness: true
end
