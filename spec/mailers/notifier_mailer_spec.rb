require "rails_helper"

RSpec.describe NotifierMailer, type: :mailer do
  let(:user) { FactoryBot.build(:user) }
  let!(:notify_message) { FactoryBot.create(:notify_message) }

  let(:mail) { NotifierMailer.missing_tasks(user, Time.now) }

  describe '#missing_tasks' do
    it { expect(mail.subject).to eq 'Calendar Time Tracking - Notificação' }
    it { expect(mail.to).to eq [user.email] }
  end
end
