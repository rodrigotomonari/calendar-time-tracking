class Project < ApplicationRecord
  extend Enumerize

  belongs_to :client
  has_many :subprojects, inverse_of: :project

  accepts_nested_attributes_for :subprojects, allow_destroy: true, reject_if: :all_blank

  enumerize :status, in: [:active, :inactive]

  validates :name, presence: true, uniqueness: true
  validates :client, presence: true
  validates :status, presence: true, inclusion: { in: Subproject.status.values }


end
