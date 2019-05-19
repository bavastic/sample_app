# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'OptionsProduct', class: ProductsController do
  include ApiJsonSupport

  let(:service_class) { ProductService }

  describe 'GET api/products/options' do
    let(:path) { '/api/products/options' }
    let(:execute) { get path }
    let!(:category) { create(:category) }
    let(:products_count) { 10 }
    let!(:products) { create_list(:product, products_count, category: category) }
    let(:service_method) { :fetch! }

    context 'without params' do
      before { execute }

      it { expect(response.status).to eq(200) }
      it { expect(json.count).to be products.size }

      it 'has filled fields' do
        json.each do |product_resp|
          product = products.find { |c| c.id == product_resp[:value] }

          expect(product_resp[:value]).to eq product.id
          expect(product_resp[:text]).to eq product.name
        end
      end
    end

    context 'check the service interface' do
      let(:service) { double }

      let!(:pagination_value_object) do
        service_class.new.paginate_relation(relation: Product.all)
      end

      it 'is called with params' do
        expect(service_class).to receive(:new).and_return(service)

        expect(service).to(
          receive(service_method).with(sort: { name: :asc }).and_return(products)
        )

        execute
      end
    end

    context 'internal error' do
      let(:error) do
        {
          notification: {
            level: 'error',
            message: 'Cannot fetch products: unknown error!'
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
            message: 'Cannot fetch products: record not found!'
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
            message: 'Cannot fetch products!'
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
