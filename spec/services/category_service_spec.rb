# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CategoryService do
  subject { described_class.new }

  describe '#fetch!' do
    let(:execute) { subject.fetch!(search: search, sort: sort, pagination: pagination) }
    let(:search) { '' }
    let(:sort) { {} }
    let(:pagination) { {} }
    let(:categories_count) { 10 }
    let!(:categories) { create_list(:category, categories_count) }

    context 'without params' do
      it 'preloads associations' do
        expect(execute.collection.first.association(:parent)).to be_loaded
      end

      it { expect(execute.collection.size).to eq(categories_count) }
      it { expect(execute).to be_a Helpers::Pagination::ResponseValueObject }
      it { expect(execute.collection).to all(be_a Category) }
      it { expect(execute.collection.map(&:id)).to match_array(categories.map(&:id)) }
    end

    context 'with pagination' do
      let(:current_page) { 2 }
      let(:page_size) { 2 }
      let(:pagination) { { current_page: current_page, page_size: page_size } }
      let(:paginated_ids) do
        categories.slice((current_page - 1) * page_size, page_size).map(&:id)
      end

      it { expect(execute).to be_a Helpers::Pagination::ResponseValueObject }
      it { expect(execute.collection.size).to eq(page_size) }
      it { expect(execute.collection).to all(be_a Category) }
      it { expect(execute.collection.map(&:id)).to match_array(paginated_ids) }
      it { expect(execute.total_count).to be categories_count }
      it { expect(execute.limit_value).to be page_size }
      it { expect(execute.total_pages).to be((categories_count / page_size)) }
      it { expect(execute.current_page).to be current_page }
    end

    context 'with sort' do
      context 'incremental by id' do
        let(:sort) { { id: :asc } }
        let(:sorted_ids) { categories.map(&:id).sort }

        it { expect(execute.collection.size).to eq(categories.size) }
        it { expect(execute.collection.map(&:id)).to eq(sorted_ids) }
      end

      context 'decremental by id' do
        let(:sort) { { id: :desc } }
        let(:sorted_ids) { categories.map(&:id).sort { |x, y| y <=> x } }

        it { expect(execute.collection.size).to eq(categories.size) }
        it { expect(execute.collection.map(&:id)).to eq(sorted_ids) }
      end
    end

    context 'with search' do
      let(:search) { categories.last.name }

      it { expect(execute.collection.size).to be 1 }
      it { expect(execute.collection.first).to eq categories.last }
    end

    context 'with multiple params' do
      let(:category) { categories.last }
      let(:total_count) { 1 }
      let(:current_page) { 1 }
      let(:page_size) { 10 }
      let(:pagination) { { current_page: current_page, page_size: page_size } }
      let(:search) { category.name }
      let(:sort) { { id: :asc } }

      it { expect(execute).to be_a Helpers::Pagination::ResponseValueObject }
      it { expect(execute.collection.size).to be total_count }
      it { expect(execute.collection).to all(be_a Category) }
      it { expect(execute.collection.first).to eq(category) }
      it { expect(execute.total_count).to be total_count }
      it { expect(execute.limit_value).to be page_size }
      it { expect(execute.total_pages).to be total_count }
      it { expect(execute.current_page).to be current_page }
    end
  end

  describe '#find!' do
    let(:execute) { subject.find!(category_id: category_id) }

    context 'valid category id' do
      let(:category) { create(:category) }
      let(:category_id) { category.id }

      it { expect(execute).to eq category }
    end

    context 'invalid category id' do
      let(:category_id) { 0 }

      it 'raises error' do
        expect { execute }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#create!' do
    let(:execute) { subject.create!(category_attr: category_attr) }
    let!(:category_parent) { create(:category) }

    context 'with valid category attr' do
      let(:category_attr) { attributes_for(:category, parent: category_parent) }

      it 'creates category' do
        expect { execute }.to(change(Category, :count).by(1))
      end

      it 'returns category' do
        expect(execute).to be_a Category
      end

      it 'sets fields for category' do
        expect(execute.name).to eq(category_attr[:name])
        expect(execute.parent_id).to eq(category_attr[:parent_id])
      end
    end

    context 'invalid category attr' do
      let(:category_attr) { {} }

      it 'raises error' do
        expect { execute }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#update!' do
    let(:execute) { subject.update!(category_id: category.id, category_attr: category_attr) }
    let(:category) { create(:category) }

    context 'with valid category attr' do
      let(:category_attr) { attributes_for(:category) }

      it 'touch updated date' do
        expect { execute }.to(change { category.reload.updated_at })
      end

      it 'changes attributes' do
        execute
        expect(category.reload).to have_attributes(category_attr)
      end

      it 'returns category' do
        expect(execute).to be_a Category
      end
    end

    context 'invalid category attr' do
      let(:category_attr) { attributes_for(:category).transform_values { |_v| '' } }

      it { expect { execute }.to raise_error(ActiveRecord::RecordInvalid) }
    end
  end

  describe '#destroy!' do
    let(:execute) { subject.destroy!(category_id: category_id) }

    context 'with valid id' do
      let!(:category) { create(:category) }
      let(:category_id) { category.id }

      it 'deletes category' do
        expect { execute }.to(change(Category, :count).by(-1))
      end

      it 'returns category' do
        expect(execute).to be_a Category
      end
    end

    context 'with invalid category id' do
      let(:category_id) { 0 }

      it 'raises error' do
        expect { execute }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#categories_count' do
    let(:execute) { subject.categories_count }
    let(:categories_count) { 10 }
    let!(:categories) { create_list(:category, categories_count) }

    it { expect(execute).to be categories_count }
  end
end
