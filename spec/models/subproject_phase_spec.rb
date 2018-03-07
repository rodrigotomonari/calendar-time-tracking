require 'rails_helper'

RSpec.describe SubprojectPhase, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:subproject) }
    it { is_expected.to belong_to(:phase) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:subproject) }
    it { is_expected.to validate_presence_of(:phase) }
  end
end
