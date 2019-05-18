# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'UpdateCategory', class: CategoriesController do
  include ApiJsonSupport

  describe 'PUT api/categories' do
    let(:path) { "/api/categories/#{category_id}" }
    let(:execute) { put path, params: category_params }
    let(:category) { create(:category, parent: category_parent) }
    let(:category_parent) { create(:category) }
    let(:category_parent_new) { create(:category) }
    let(:category_id) { category.id }

    let(:category_params) do
      {
        category: {
          name: Faker::Name.name,
          parentId: category_parent_new.id
        }
      }
    end

    context 'with wrong id param' do
      let(:category_id) { 0 }

      before { execute }

      it { expect(response.status).to eq(404) }
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
          parentId: category_parent_new.id,
          parentName: category_parent_new.name,
          productsCount: 0
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
        expect(json[:displayName]).to_not be_blank
      end

      it { expect { execute }.to(change { category.reload.name }) }
      it { expect { execute }.to(change { category.reload.parent_id }) }
      it { expect { execute }.to_not(change { category.reload.id }) }
    end

    context 'check the service interface' do
      let(:service) { double }

      let(:category_attr) do
        {
          name: category_params[:category][:name],
          parent_id: category_params[:category][:parentId].to_s
        }
      end

      it 'is called with params' do
        expect(CategoryService).to receive(:new).and_return(service)

        expect(service).to(
          receive(:update!).with(category_id: category.id.to_s, category_attr: category_attr).and_return(category)
        )

        execute
      end
    end
  end
end
