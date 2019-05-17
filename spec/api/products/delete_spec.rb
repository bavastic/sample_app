# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'DeleteProduct', class: ProductsController do
  describe 'DELETE api/products/:id' do
    let(:path) { "/api/products/#{product_id}" }
    let(:execute) { delete path }
    let(:category) { create(:category) }
    let(:product) { create(:product, category: category) }
    let(:product_id) { product.id }

    context 'with wrong id param' do
      let(:product_id) { 0 }

      before { execute }

      it { expect(response.status).to eq(404) }
    end

    context 'with id param' do
      before { execute }

      it { expect(response.status).to eq(200) }
    end

    context 'check the service interface' do
      let(:service) { double }

      it 'is called with params' do
        expect(ProductService).to receive(:new).and_return(service)

        expect(service).to(
          receive(:destroy!).with(product_id: product.id.to_s).and_return(product)
        )

        execute
      end
    end
  end
end
