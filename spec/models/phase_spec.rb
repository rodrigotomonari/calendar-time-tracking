require 'rails_helper'

RSpec.describe Phase, type: :model do
  describe 'associations' do
    it { is_expected.to have_many :subproject_phases }
    it { is_expected.to have_many(:subprojects).through(:subproject_phases) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
