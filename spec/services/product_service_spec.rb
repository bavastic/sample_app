# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ProductService do
  subject { described_class.new }
  let(:category) { create(:category) }

  describe '.fetch!' do
    let(:execute) { subject.fetch!(search: search, sort: sort, pagination: pagination) }
    let(:search) { '' }
    let(:sort) { {} }
    let(:pagination) { {} }
    let(:product_count) { 10 }
    let!(:products) { create_list(:product, product_count, category: category) }

    context 'without params' do
      it { expect(execute.collection.size).to eq(product_count) }
      it { expect(execute).to be_a Helpers::Pagination::ResponseValueObject }
      it { expect(execute.collection).to all(be_a Product) }
      it { expect(execute.collection.map(&:id)).to match_array(products.map(&:id)) }
    end

    context 'with pagination' do
      let(:current_page) { 2 }
      let(:page_size) { 2 }
      let(:pagination) { { current_page: current_page, page_size: page_size } }
      let(:paginated_ids) do
        products.slice((current_page - 1) * page_size, page_size).map(&:id)
      end

      it { expect(execute).to be_a Helpers::Pagination::ResponseValueObject }
      it { expect(execute.collection.size).to eq(page_size) }
      it { expect(execute.collection).to all(be_a Product) }
      it { expect(execute.collection.map(&:id)).to match_array(paginated_ids) }
      it { expect(execute.total_count).to be product_count }
      it { expect(execute.limit_value).to be page_size }
      it { expect(execute.total_pages).to be (product_count / page_size) }
      it { expect(execute.current_page).to be current_page }
    end

    context 'with sort' do
      context 'incremental by id' do
        let(:sort) { { id: :asc } }
        let(:sorted_ids) { products.map(&:id).sort }

        it { expect(execute.collection.size).to eq(products.size) }
        it { expect(execute.collection.map(&:id)).to eq(sorted_ids) }
      end

      context 'decremental by id' do
        let(:sort) { { id: :desc } }
        let(:sorted_ids) { products.map(&:id).sort { |x, y| y <=> x } }

        it { expect(execute.collection.size).to eq(products.size) }
        it { expect(execute.collection.map(&:id)).to eq(sorted_ids) }
      end
    end

    context 'with search' do
      let(:search) { products.last.name }

      it { expect(execute.collection.size).to be 1 }
      it { expect(execute.collection.first).to eq products.last }
    end

    context 'with multiple params' do
      let(:product) { products.last }
      let(:total_count) { 1 }
      let(:current_page) { 1 }
      let(:page_size) { 10 }
      let(:pagination) { { current_page: current_page, page_size: page_size } }
      let(:search) { product.name }
      let(:sort) { { id: :asc } }

      it { expect(execute).to be_a Helpers::Pagination::ResponseValueObject }
      it { expect(execute.collection.size).to be total_count }
      it { expect(execute.collection).to all(be_a Product) }
      it { expect(execute.collection.first).to eq(product) }
      it { expect(execute.total_count).to be total_count }
      it { expect(execute.limit_value).to be page_size }
      it { expect(execute.total_pages).to be total_count }
      it { expect(execute.current_page).to be current_page }
    end
  end

  describe '.find!' do
    let(:execute) { subject.find!(product_id: product_id) }

    context 'valid product id' do
      let(:product) { create(:product, category: category) }
      let(:product_id) { product.id }

      it { expect(execute).to eq product }
    end

    context 'invalid product id' do
      let(:product_id) { 0 }

      it 'raises error' do
        expect { execute }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '.create!' do
    let(:execute) { subject.create!(product_attr: product_attr) }
    let!(:product) { create(:product, category: category) }

    context 'with valid product attr' do
      let(:product_attr) { attributes_for(:product, category_id: category.id) }

      it 'creates product' do
        expect { execute }.to(change(Product, :count).by(1))
      end

      it 'returns product' do
        expect(execute).to be_a Product
      end

      it 'sets fields for product' do
        expect(execute.name).to eq(product_attr[:name])
        expect(execute.category_id).to eq(product_attr[:category_id])
      end
    end

    context 'invalid product attr' do
      let(:product_attr) { {} }

      it 'raises error' do
        expect { execute }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '.update!' do
    let(:execute) { subject.update!(product_id: product.id, product_attr: product_attr) }
    let(:product) { create(:product, category: category) }

    context 'with valid product attr' do
      let(:product_attr) { attributes_for(:product) }

      it 'touch updated date' do
        expect { execute }.to(change { product.reload.updated_at } )
      end

      it 'changes attributes' do
        execute
        expect(product.reload).to have_attributes(product_attr.except(:price))
        expect(product.reload.price.to_s).to eq product_attr[:price]
      end

      it 'returns product' do
        expect(execute).to be_a Product
      end
    end

    context 'invalid product attr' do
      let(:product_attr) { attributes_for(:product).transform_values {|_v| '' } }

      it { expect { execute }.to raise_error(ActiveRecord::RecordInvalid) }
    end
  end

  describe '.destroy!' do
    let(:execute) { subject.destroy!(product_id: product_id) }

    context 'with valid id' do
      let!(:product) { create(:product, category: category) }
      let(:product_id) { product.id }

      it 'deletes product' do
        expect { execute }.to(change(Product, :count).by(-1))
      end

      it 'returns product' do
        expect(execute).to be_a Product
      end
    end

    context 'with invalid product id' do
      let(:product_id) { 0 }

      it 'raises error' do
        expect { execute }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '.product_count' do
    let(:execute) { subject.product_count }
    let(:product_count) { 10 }
    let!(:products) { create_list(:product, product_count, category: category)}

    it { expect(execute).to be product_count }
  end
end
