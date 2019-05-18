# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'CreateProduct', class: ProductsController do
  include ApiJsonSupport

  describe 'POST api/products' do
    let(:path) { '/api/products' }
    let(:execute) { post path, params: product_params }
    let!(:category) { create(:category) }

    let(:product_params) do
      {
        product: {
          name: Faker::Name.name,
          categoryId: category.id,
          price: Faker::Number.decimal(2, 2),
          currency: Faker::Currency.code,
          displayCurrency: Faker::Currency.code
        }
      }
    end

    context 'with missing fields' do
      let(:product_params) { {} }
      before { execute }

      it { expect(response.status).to eq(500) }
    end

    context 'with filled valid fields' do
      let(:json_response) do
        {
          name: product_params[:product][:name],
          displayName: product_params[:product][:name],
          categoryId: category.id,
          categoryName: category.name,
          price: product_params[:product][:price],
          currency: product_params[:product][:currency],
          displayCurrency: product_params[:product][:displayCurrency]
        }
      end

      before { execute }

      it { expect(response.status).to eq(200) }

      it 'returns json' do
        expect(json).to include(json_response)
        expect(json[:id]).to_not be_blank
      end
    end

    context 'check the service interface' do
      let(:service) { double }
      let(:product) { create(:product, category: category) }

      let(:product_attr) do
        {
          name: product_params[:product][:name],
          category_id: product_params[:product][:categoryId].to_s,
          price: product_params[:product][:price].to_s,
          currency: product_params[:product][:currency],
          display_currency: product_params[:product][:displayCurrency]
        }
      end

      it 'is called with params' do
        expect(ProductService).to receive(:new).and_return(service)

        expect(service).to(
          receive(:create!).with(product_attr: product_attr).and_return(product)
        )

        execute
      end
    end
  end
end
