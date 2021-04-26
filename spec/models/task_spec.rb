require 'rails_helper'

RSpec.describe Task, type: :model do

  let(:task) { build(:task) }

  context 'when is new task' do
    it { is_expected.to belong_to :user }

    it { expect(task).to_not be_done }

    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :user_id }

    it { is_expected.to respond_to :title }
    it { is_expected.to respond_to :description }
    it { is_expected.to respond_to :done }
    it { is_expected.to respond_to :deadline }
    it { is_expected.to respond_to :user_id }
  end

end
