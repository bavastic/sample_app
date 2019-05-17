# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'DeleteCategory', class: CategoriesController do
  describe 'DELETE api/categories/:id' do
    let(:path) { "/api/categories/#{category_id}" }
    let(:execute) { delete path }
    let(:category) { create(:category) }
    let(:category_id) { category.id }

    context 'with wrong id param' do
      let(:category_id) { 0 }

      before { execute }

      it { expect(response.status).to eq(404) }
    end

    context 'with id param' do
      before { execute }

      it { expect(response.status).to eq(200) }
    end

    context 'check the service interface' do
      let(:service) { double }

      it 'is called with params' do
        expect(CategoryService).to receive(:new).and_return(service)

        expect(service).to(
          receive(:destroy!).with(category_id: category.id.to_s).and_return(category)
        )

        execute
      end
    end
  end
end
