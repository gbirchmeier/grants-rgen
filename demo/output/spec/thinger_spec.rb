require 'rails_helper'

RSpec.describe thinger, type: :model do
  let(:thinger1) { FactoryBot.create(:thinger) }

  context 'simple validations' do
    before(:example) { thinger1 }

    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:product_line).with_message('must exist') }
  end
end
