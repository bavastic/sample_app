# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'OptionsProduct', class: CategoriesController do
  include ApiJsonSupport

  describe 'GET api/products/options' do
    let(:path) { '/api/products/options' }
    let(:execute) { get path }
    let!(:category) { create(:category) }
    let(:product_count) { 10 }
    let!(:products) { create_list(:product, product_count, category: category) }
    let(:service_class) { ProductService }

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
          receive(:fetch!).with(sort: { name: :asc }).and_return(products)
        )

        execute
      end
    end
  end
end
