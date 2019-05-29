# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'GetOneCategory', class: CategoriesController do
  include ApiJsonSupport

  let(:service_class) { CategoryService }

  describe 'GET api/categories/:id' do
    let(:path) { "/api/categories/#{category_id}" }
    let(:execute) { get path }
    let(:category_id) { category.id }
    let(:category_parent) { create(:category) }
    let(:category) { create(:category, parent: category_parent) }
    let(:service_method) { :find! }

    context 'with correct id param' do
      let(:products_count) { 10 }
      let!(:products) { create_list(:product, products_count, category: category) }

      let(:json_response) do
        {
          id: category.id,
          displayName: "#{category.parent.name} > #{category.name}",
          name: category.name,
          parentId: category_parent.id,
          parentName: category_parent.name,
          productsCount: products_count
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
          receive(service_method).with(category_id: category.id.to_s).and_return(category)
        )

        execute
      end
    end

    context 'internal error' do
      let(:error) do
        {
          notification: {
            level: 'error',
            message: 'Cannot show category: unknown error!'
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
            message: 'Cannot show category: record not found!'
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
            message: 'Cannot show category!'
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
