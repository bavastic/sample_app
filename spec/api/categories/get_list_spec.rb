# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'GetListCategory', class: CategoriesController do
  include ApiJsonSupport

  describe 'GET api/categories' do
    let(:path) { '/api/categories' }
    let(:execute) { get path, params: fetch_params }
    let(:category_parent) { create(:category) }
    let(:categories_count) { 3 }
    let!(:categories) { create_list(:category, categories_count, parent: category_parent) }
    let(:all_categories) { [category_parent] + categories }
    let(:products_count) { 2 }
    let(:fetch_params) { {} }
    let(:service_class) { CategoryService }

    before do
      all_categories.each { |category| create_list(:product, products_count, category: category) }
    end

    context 'without params' do
      before { execute }

      it { expect(response.status).to eq(200) }
      it { expect(json.count).to be all_categories.size }

      it 'has filled fields' do
        json.each do |category_resp|
          category = all_categories.find { |c| c.id == category_resp[:id] }

          expect(category_resp[:name]).to eq category.name
          if category.parent # in case of parent there is a special display name
            expect(category_resp[:displayName]).to eq "#{category.parent.name} > #{category.name}"
          else
            expect(category_resp[:displayName]).to eq category.name
          end
          expect(category_resp[:parentName]).to eq category.parent&.name
          expect(category_resp[:productsCount]).to eq category.products_count
          expect(category_resp[:parentId]).to eq category.parent_id
        end
      end
    end

    context 'check the service interface' do
      let(:service) { double }
      let(:fetch_params) do
        {
          query: 'Name',
          per_page: 10,
          page: 1
        }
      end

      let(:fetch_attr) do
        {
          search: fetch_params[:query],
          sort: { id: :asc },
          pagination: { current_page: fetch_params[:page].to_s, page_size: fetch_params[:per_page].to_s }
        }
      end

      let!(:pagination_value_object) do
        service_class.new.paginate_relation(
          relation: Category.all,
          current_page: fetch_params[:page].to_s,
          page_size: fetch_params[:per_page].to_s
        )
      end

      it 'is called with params' do
        expect(service_class).to receive(:new).and_return(service)

        expect(service).to(
          receive(:fetch!).with(fetch_attr).and_return(pagination_value_object)
        )

        execute
      end
    end
  end
end
