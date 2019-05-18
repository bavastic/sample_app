# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id               :bigint           not null, primary key
#  category_id      :bigint
#  name             :string           not null
#  price            :decimal(, )
#  currency         :string           default("EUR")
#  display_currency :string           default("EUR")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Product do
  subject { described_class }

  describe '#save' do
    context 'with valid params' do
      let(:category) { create(:category) }
      let(:model) { build(:product, category: category) }

      it { expect { model.save }.to change { Product.count }.by(1) }

      it 'increments the products_count on category' do
        expect { model.save }.to change { category.reload.products_count }.by(1)
      end

      it 'setups the identifier' do
        expect { model.save }.to change { model.p_identifier }.from(nil).to(%r{\A\w{3}/\w{3}\z})
      end

      it 'it doesnt rewrite the identifier' do
        model.save
        expect { model.save }.to_not(change { model.reload.p_identifier })
      end
    end

    context 'without required params' do
      let!(:model) { described_class.new }
      before { model.validate }

      it { expect(model.errors.messages.size).to be 2 }

      it { expect(model.errors.messages[:name]).to eq(['can\'t be blank']) }
      it { expect(model.errors.messages[:category]).to eq(['must exist']) }
    end

    context 'without price' do
      let!(:model) { create(:product, price: nil) }

      it 'fills out the default value' do
        expect(model).to have_attributes(price: 0.0)
      end
    end
  end

  describe '#destroy' do
    let!(:model) { create(:product) }
    it { expect { model.destroy }.to change { Product.count }.by(-1) }
  end

  describe '.search_by_query' do
    let(:search) { 'search' }
    let!(:model) { create(:product, name: "#{Faker::Name.name}#{search}#{Faker::Name.name}") }
    it { expect(subject.search_by(query: search.upcase)).to include(model) }
  end
end
