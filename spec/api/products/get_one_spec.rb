# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'GetOneProduct', class: ProductsController do
  include ApiJsonSupport

  describe 'GET api/products/:id' do
    let(:path) { "/api/products/#{product_id}" }
    let(:execute) { get path }
    let(:product_id) { product.id }
    let!(:category) { create(:category) }
    let!(:product) { create(:product, category: category) }

    context 'with wrong id param' do
      let(:product_id) { 0 }

      before { execute }

      it { expect(response.status).to eq(404) }
    end

    context 'with correct id param' do
      let(:json_response) do
        {
          id: product.id,
          displayName: product.displayName,
          name: product.name,
          categoryId: category.id,
          categoryName: category.name,
          displayCurrency: product.displayCurrency
        }
      end

      before { execute }

      it { expect(response.status).to eq(200) }
      it { expect(json).to include(json_response) }
    end

    context 'check the service interface' do
      let(:service) { double }

      it 'is called with params' do
        expect(ProductService).to receive(:new).and_return(service)

        expect(service).to(
          receive(:find!).with(product_id: product.id.to_s).and_return(product)
        )

        execute
      end
    end
  end
end
