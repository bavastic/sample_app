# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id             :bigint           not null, primary key
#  parent_id      :bigint
#  name           :string           not null
#  products_count :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Category do
  subject { described_class }

  describe '#save' do
    context 'with valid params' do
      let(:model) { build(:category) }

      it { expect { model.save }.to change { Category.count }.by(1) }
    end

    context 'without required params' do
      let!(:model) { described_class.new }
      before { model.validate }

      it { expect(model.errors.messages.size).to be 1 }
      it { expect(model.errors.messages[:name]).to eq(['can\'t be blank']) }
    end

    context 'when the category parent id refer to own id' do
      let!(:model) { create(:category) }

      it 'raise the validation error' do
        expect { model.update!(parent: model) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#destroy' do
    let!(:model) { create(:category) }
    let!(:child) { create(:category, parent: model) }
    let!(:product) { create(:product, category: child) }

    it 'destroys with child categories relation' do
      expect { model.destroy }.to change { Category.count }.by(-2)
    end

    it 'destroys with products' do
      expect { model.destroy }.to change { Product.count }.by(-1)
    end
  end

  describe '.search_by_query' do
    let(:search) { 'search' }
    let!(:model) { create(:category, name: "#{Faker::Name.name}#{search}#{Faker::Name.name}") }
    it { expect(subject.search_by(query: search.upcase)).to include(model) }
  end
end
