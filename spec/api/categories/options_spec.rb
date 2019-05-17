# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'OptionsCategory', class: CategoriesController do
  include ApiJsonSupport

  describe 'GET api/categories/options' do
    let(:path) { '/api/categories/options' }
    let(:execute) { get path }
    let(:category_count) { 10 }
    let!(:categories) { create_list(:category, category_count) }
    let(:service_class) { CategoryService }

    context 'without params' do
      before { execute }

      it { expect(response.status).to eq(200) }
      it { expect(json.count).to be categories.size }

      it 'has filled fields' do
        json.each do |category_resp|
          category = categories.find { |c| c.id == category_resp[:value] }

          expect(category_resp[:value]).to eq category.id
          expect(category_resp[:text]).to eq category.name
        end
      end
    end

    context 'check the service interface' do
      let(:service) { double }

      let!(:pagination_value_object) do
        service_class.new.paginate_relation(relation: Category.all)
      end

      it 'is called with params' do
        expect(service_class).to receive(:new).and_return(service)

        expect(service).to(
          receive(:fetch!).with(sort: { name: :asc }).and_return(categories)
        )

        execute
      end
    end
  end
end
