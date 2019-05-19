# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'CreateCategory', class: CategoriesController do
  include ApiJsonSupport

  let(:service_class) { CategoryService }

  describe 'POST api/categories' do
    let(:path) { '/api/categories' }
    let(:execute) { post path, params: category_params }
    let(:category_parent) { create(:category) }
    let(:service_method) { :create! }

    let(:category_params) do
      {
        category: {
          name: Faker::Name.name,
          parentId: category_parent.id
        }
      }
    end

    context 'with missing fields' do
      let(:category_params) { {} }
      before { execute }

      it { expect(response.status).to eq(500) }
    end

    context 'with filled valid fields' do
      let(:json_response) do
        {
          name: category_params[:category][:name],
          parentId: category_parent.id,
          parentName: category_parent.name,
          productsCount: 0
        }
      end

      before { execute }

      it { expect(response.status).to eq(200) }

      it 'returns json' do
        expect(json).to include(json_response)
        expect(json[:id]).to_not be_blank
        expect(json[:displayName]).to_not be_blank
      end
    end

    context 'check the service interface' do
      let(:service) { double }
      let(:category) { create(:category) }

      let(:category_attr) do
        {
          name: category_params[:category][:name],
          parent_id: category_params[:category][:parentId].to_s
        }
      end

      it 'is called with params' do
        expect(service_class).to receive(:new).and_return(service)

        expect(service).to(
          receive(service_method).with(category_attr: category_attr).and_return(category)
        )

        execute
      end
    end

    context 'internal error' do
      let(:error) do
        {
          notification: {
            level: 'error',
            message: 'Cannot create category: unknown error!'
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
            message: 'Cannot create category: record not found!'
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
            message: 'Cannot create category!'
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
