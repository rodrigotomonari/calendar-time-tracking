class Project < ApplicationRecord
  extend Enumerize

  belongs_to :client
  has_many :subprojects, inverse_of: :project

  accepts_nested_attributes_for :subprojects, allow_destroy: true, reject_if: :all_blank

  enumerize :status, in: %i[active inactive], default: :active

  validates :name, presence: true, uniqueness: true
  validates :client, presence: true
  validates :status, presence: true, inclusion: { in: Project.status.values }
end
