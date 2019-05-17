# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'CreateCategory', class: CategoriesController do
  include ApiJsonSupport

  describe 'POST api/categories' do
    let(:path) { '/api/categories' }
    let(:execute) { post path, params: category_params }
    let(:category_parent) { create(:category) }

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

    # context 'with invalid fields' do
    #   context 'parent id is not exist' do
    #     let!(:other_category) do
    #       create(:category,
    #              :external,
    #              key: category_params[:data][:attributes][:key],
    #              name: category_params[:data][:attributes][:name])
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
          name: category_params[:category][:name],
          parentId: category_parent.id,
          parentName: category_parent.name,
          productsCount: nil
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
        expect(CategoryService).to receive(:new).and_return(service)

        expect(service).to(
          receive(:create!).with(category_attr: category_attr).and_return(category)
        )

        execute
      end
    end
  end
end
