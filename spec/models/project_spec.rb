require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:client) }
    it { is_expected.to have_many(:subprojects).inverse_of(:project) }
  end

  describe 'enumerize' do
    it { is_expected.to enumerize(:status) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:client) }
    it { is_expected.to validate_inclusion_of(:status).in_array(Project.status.values) }
  end

  it { is_expected.to accept_nested_attributes_for(:subprojects).allow_destroy(true) }
end
