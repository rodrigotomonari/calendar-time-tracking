require 'rails_helper'

RSpec.describe Subproject, type: :model do
  it { is_expected.to delegate_method(:color).to(:project) }
  it { is_expected.to delegate_method(:name).to(:project).with_prefix }
  it { is_expected.to accept_nested_attributes_for(:subproject_phases).allow_destroy(true) }

  describe 'associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_many(:subproject_phases).inverse_of(:subproject) }
    it { is_expected.to have_many(:phases).through(:subproject_phases) }
  end

  describe 'enumerize' do
    it { is_expected.to enumerize(:status) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_inclusion_of(:status).in_array(Subproject.status.values) }
  end
end
