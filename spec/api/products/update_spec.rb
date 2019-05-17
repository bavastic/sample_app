# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'UpdateProduct', class: ProductsController do
  include ApiJsonSupport

  describe 'PUT api/products' do
    let(:path) { "/api/products/#{product_id}" }
    let(:execute) { put path, params: product_params }
    let(:category) { create(:category) }
    let(:product) { create(:product, category: category) }
    let(:category_new) { create(:category) }
    let(:product_id) { product.id }

    let(:product_params) do
      {
        product: {
          name: Faker::Name.name,
          categoryId: category_new.id,
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

    # context 'with invalid fields' do
    #   context 'parent id is not exist' do
    #     let!(:other_product) do
    #       create(:product,
    #              :external,
    #              key: product_params[:data][:attributes][:key],
    #              name: product_params[:data][:attributes][:name])
    #     end

    #     it { expect(response.status).to eq(422) }

    #     it 'returns active record errors' do
    #       expect(jsonapi_errors.map { |e| jsonapi_error_source_pointer(error: e) }).to eq(['/data/attributes/key',
    #                                                                                        '/data/attributes/name'])
    #       expect(jsonapi_errors.map { |e| jsonapi_error_title(error: e) }).to eq(['has already been taken',
    #                                                                               'has already been taken'])
    #     end
    #   end
    # end

    context 'with filled valid fields' do
      let(:json_response) do
        {
          name: product_params[:product][:name],
          displayName: product_params[:product][:name],
          categoryId: category_new.id,
          categoryName: category_new.name,
          price: product_params[:product][:price],
          currency:  product_params[:product][:currency],
          displayCurrency:  product_params[:product][:displayCurrency]
        }
      end

      it 'return success' do
        execute
        expect(response.status).to eq(200)
      end

      it 'returns json' do
        execute
        expect(json).to include(json_response)
        expect(json[:id]).to_not be_blank
      end

      it { expect { execute }.to change { product.reload.name } }
      it { expect { execute }.to change { product.reload.category_id } }
      it { expect { execute }.to change { product.reload.price } }
      it { expect { execute }.to change { product.reload.currency } }
      it { expect { execute }.to change { product.reload.displayCurrency } }
      it { expect { execute }.to_not(change { product.reload.id }) }
    end

    context 'check the service interface' do
      let(:service) { double }

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
          receive(:update!).with(product_id: product.id.to_s, product_attr: product_attr).and_return(product)
        )

        execute
      end
    end
  end
end
