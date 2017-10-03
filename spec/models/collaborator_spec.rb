require 'rails_helper'

RSpec.describe Collaborator, type: :model do
    let(:user) { create(:user) }
    let(:wiki) { create(:wiki) }
    let(:collaboration) { Collaborator.create!(wiki: wiki, user: user) }

    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:wiki) }
end
