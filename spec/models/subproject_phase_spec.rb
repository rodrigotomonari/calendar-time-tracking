require 'rails_helper'

RSpec.describe SubprojectPhase, type: :model do
  it { is_expected.to delegate_method(:color).to(:subproject) }
  it { is_expected.to respond_to(:title) }

  describe 'associations' do
    it { is_expected.to belong_to(:subproject) }
    it { is_expected.to belong_to(:phase) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:subproject) }
    it { is_expected.to validate_presence_of(:phase) }
  end
end
