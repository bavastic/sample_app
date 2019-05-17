# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'GetOneCategory', class: CategoriesController do
  include ApiJsonSupport

  describe 'GET api/categories/:id' do
    let(:path) { "/api/categories/#{category_id}" }
    let(:execute) { get path }
    let(:category_id) { category.id }
    let(:category_parent) { create(:category) }
    let(:category) { create(:category, parent: category_parent) }

    context 'with wrong id param' do
      let(:category_id) { 0 }

      before { execute }

      it { expect(response.status).to eq(404) }
    end

    context 'with correct id param' do
      let(:product_count) { 10 }
      let!(:products) { create_list(:product, product_count, category: category) }

      let(:json_response) do
        {
          id: category.id,
          displayName: category.displayName,
          name: category.name,
          parentId: category_parent.id,
          parentName: category_parent.name,
          productsCount: product_count
        }
      end

      before { execute }

      it { expect(response.status).to eq(200) }
      it { expect(json).to include(json_response) }
    end

    context 'check the service interface' do
      let(:service) { double }

      it 'is called with params' do
        expect(CategoryService).to receive(:new).and_return(service)

        expect(service).to(
          receive(:find!).with(category_id: category.id.to_s).and_return(category)
        )

        execute
      end
    end
  end
end
