require 'rails_helper'

RSpec.describe NotifyMessage, type: :model do
  it { is_expected.to validate_presence_of(:message) }
end
