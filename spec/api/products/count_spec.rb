# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'CountProduct', class: CategoriesController do
  include ApiJsonSupport

  describe 'GET api/products/count' do
    let(:path) { '/api/products/count' }
    let(:execute) { get path }
    let!(:category) { create(:category) }
    let(:product_count) { 10 }
    let!(:products) { create_list(:product, product_count, category: category) }

    context 'check the http response' do
      before { execute }

      it { expect(response.status).to eq(200) }
      it { expect(json).to eq({ count: product_count }) }
    end

    context 'check the service interface' do
      let(:service) { double }

      it 'is called with params' do
        expect(ProductService).to receive(:new).and_return(service)

        expect(service).to(
          receive(:product_count).and_return(product_count)
        )

        execute
      end
    end
  end
end