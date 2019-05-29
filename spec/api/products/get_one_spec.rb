# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'GetOneProduct', class: ProductsController do
  include ApiJsonSupport

  let(:service_class) { ProductService }

  describe 'GET api/products/:id' do
    let(:path) { "/api/products/#{product_id}" }
    let(:execute) { get path }
    let(:product_id) { product.id }
    let!(:category) { create(:category) }
    let!(:product) { create(:product, category: category) }
    let(:service_method) { :find! }

    context 'with wrong id param' do
      let(:product_id) { 0 }

      before { execute }

      it { expect(response.status).to eq(404) }
    end

    context 'with correct id param' do
      let(:json_response) do
        {
          id: product.id,
          displayName: product.name,
          name: product.name,
          categoryId: category.id,
          categoryName: category.name,
          displayCurrency: product.display_currency
        }
      end

      before { execute }

      it { expect(response.status).to eq(200) }
      it { expect(json).to include(json_response) }
    end

    context 'check the service interface' do
      let(:service) { double }

      it 'is called with params' do
        expect(service_class).to receive(:new).and_return(service)

        expect(service).to(
          receive(service_method).with(product_id: product.id.to_s).and_return(product)
        )

        execute
      end
    end

    context 'internal error' do
      let(:error) do
        {
          notification: {
            level: 'error',
            message: 'Cannot show product: unknown error!'
          }
        }
      end

      it 'renders error' do
        expect_any_instance_of(service_class).to(receive(service_method).and_raise(Exception))

        execute
        expect(response.status).to be 500
        expect(json).to eq(error)
      end
    end

    context 'record not found' do
      let(:error) do
        {
          notification: {
            level: 'error',
            message: 'Cannot show product: record not found!'
          }
        }
      end

      it 'renders error' do
        expect_any_instance_of(service_class).to(receive(service_method).and_raise(ActiveRecord::RecordNotFound))

        execute
        expect(response.status).to be 404
        expect(json).to eq(error)
      end
    end

    context 'record invalid' do
      let(:error) do
        {
          notification: {
            level: 'error',
            message: 'Cannot show product!'
          }
        }
      end

      it 'renders error' do
        expect_any_instance_of(service_class).to(receive(service_method).and_raise(ActiveRecord::RecordInvalid))

        execute
        expect(response.status).to be 422
        expect(json).to eq(error)
      end
    end
  end
end
