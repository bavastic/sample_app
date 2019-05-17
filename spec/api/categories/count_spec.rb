# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'CountCategory', class: CategoriesController do
  include ApiJsonSupport

  describe 'GET api/categories/count' do
    let(:path) { '/api/categories/count' }
    let(:execute) { get path }
    let(:category_count) { 10 }
    let!(:categories) { create_list(:category, category_count) }

    context 'check the http response' do
      before { execute }

      it { expect(response.status).to eq(200) }
      it { expect(json).to eq({ count: category_count }) }
    end

    context 'check the service interface' do
      let(:service) { double }

      it 'is called with params' do
        expect(CategoryService).to receive(:new).and_return(service)

        expect(service).to(
          receive(:category_count).and_return(category_count)
        )

        execute
      end
    end
  end
end
