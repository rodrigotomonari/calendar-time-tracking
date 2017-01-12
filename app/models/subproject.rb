class Subproject < ApplicationRecord
  extend Enumerize

  belongs_to :project
  has_many :subproject_phases, inverse_of: :subproject
  has_many :phases, through: :subproject_phases

  accepts_nested_attributes_for :subproject_phases, allow_destroy: true, reject_if: :all_blank

  enumerize :status, in: [:active, :inactive]

  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: Subproject.status.values }
end