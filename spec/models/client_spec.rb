# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do
  context 'associations' do
    it { is_expected.to have_many :projects }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
