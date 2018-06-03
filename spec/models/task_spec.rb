require 'rails_helper'

RSpec.describe Task, type: :model do
  it { is_expected.to delegate_method(:title).to(:subproject_phase) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:subproject_phase) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:subproject_phase) }
    it { is_expected.to validate_presence_of(:started_at) }
    it { is_expected.to validate_presence_of(:ended_at) }
  end

  context 'when created' do
    let(:current_time) { Time.current }
    let(:one_hour_later) { Time.current + 1.hour }
    let(:task) { Task.new started_at: current_time, ended_at: one_hour_later }

    it 'set time' do
      task.run_callbacks :save
      expect(task.time).to eq 3600
    end
  end
end
