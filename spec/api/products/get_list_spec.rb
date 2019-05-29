# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'GetListProduct', class: ProductsController do
  include ApiJsonSupport

  let(:service_class) { ProductService }

  describe 'GET api/products' do
    let(:path) { '/api/products' }
    let(:execute) { get path, params: fetch_params }
    let!(:category) { create(:category) }
    let(:products_count) { 3 }
    let!(:products) { create_list(:product, products_count, category: category) }
    let(:products_count) { 2 }
    let(:fetch_params) { {} }
    let(:service_method) { :fetch! }

    context 'without params' do
      before { execute }

      it { expect(response.status).to eq(200) }
      it { expect(json.count).to be products.size }

      it 'has filled fields' do
        json.each do |product_resp|
          product = products.find { |c| c.id == product_resp[:id] }

          expect(product_resp[:name]).to eq product.name
          expect(product_resp[:displayName]).to eq product.name
          expect(product_resp[:categoryName]).to eq category.name
          expect(product_resp[:displayCurrency]).to eq product.display_currency
          expect(product_resp[:categoryId]).to eq product.category.id
        end
      end
    end

    context 'check the service interface' do
      let(:service) { double }
      let(:fetch_params) do
        {
          query: 'Name',
          per_page: 10,
          page: 1
        }
      end

      let(:fetch_attr) do
        {
          search: fetch_params[:query],
          sort: { id: :asc },
          pagination: { current_page: fetch_params[:page].to_s, page_size: fetch_params[:per_page].to_s }
        }
      end

      let!(:pagination_value_object) do
        service_class.new.paginate_relation(
          relation: Product.all,
          current_page: fetch_params[:page].to_s,
          page_size: fetch_params[:per_page].to_s
        )
      end

      it 'is called with params' do
        expect(service_class).to receive(:new).and_return(service)

        expect(service).to(
          receive(service_method).with(fetch_attr).and_return(pagination_value_object)
        )

        execute
      end
    end

    context 'internal error' do
      let(:error) do
        {
          notification: {
            level: 'error',
            message: 'Cannot list products: unknown error!'
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
            message: 'Cannot list products: record not found!'
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
            message: 'Cannot list products!'
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
