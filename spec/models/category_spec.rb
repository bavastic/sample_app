# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id             :bigint           not null, primary key
#  parent_id      :bigint
#  name           :string
#  products_count :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#


require 'rails_helper'

RSpec.describe Category do
  describe '.save' do
    context 'with valid params' do
      let(:model) { build(:category) }

      it { expect { model.save }.to change { Category.count }.by(1) }
    end

    context 'without required params' do
      let!(:model) { described_class.new }
      before { model.validate }

      it { expect(model.errors.messages.size).to be 4 }
      it { expect(model.errors.messages[:key]).to eq(['can\'t be blank']) }
      it { expect(model.errors.messages[:name]).to eq(['can\'t be blank']) }
      it { expect(model.errors.messages[:internal]).to eq(['is not included in the list']) }
      it { expect(model.errors.messages[:auth_mode]).to eq(['must exist']) }
    end
  end

  describe '.destroy' do
    let(:model) { create(:category) }

    it { expect { model.destroy }.to change { Category.count }.by(-1) }
  end
end
