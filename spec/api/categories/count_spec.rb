# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'CountCategory', class: CategoriesController do
  include ApiJsonSupport

  describe 'GET api/categories/count' do
    let(:path) { '/api/categories/count' }
    let(:execute) { get path }
    let(:categories_count) { 10 }
    let!(:categories) { create_list(:category, categories_count) }

    context 'check the http response' do
      before { execute }

      it { expect(response.status).to eq(200) }
      it { expect(json).to eq({ count: categories_count }) }
    end

    context 'check the service interface' do
      let(:service) { double }

      it 'is called with params' do
        expect(CategoryService).to receive(:new).and_return(service)

        expect(service).to(
          receive(:categories_count).and_return(categories_count)
        )

        execute
      end
    end
  end
end
