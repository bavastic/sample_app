# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'OptionsCategory', class: CategoriesController do
  include ApiJsonSupport

  let(:service_class) { CategoryService }

  describe 'GET api/categories/options' do
    let(:path) { '/api/categories/options' }
    let(:execute) { get path }
    let(:categories_count) { 10 }
    let!(:categories) { create_list(:category, categories_count) }
    let(:service_method) { :fetch! }

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
          receive(service_method).with(sort: { name: :asc }).and_return(categories)
        )

        execute
      end
    end

    context 'internal error' do
      let(:error) do
        {
          notification: {
            level: 'error',
            message: 'Cannot fetch categories: unknown error!'
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
            message: 'Cannot fetch categories: record not found!'
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
            message: 'Cannot fetch categories!'
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
