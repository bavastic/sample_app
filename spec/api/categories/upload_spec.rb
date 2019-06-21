# frozen_string_literal: true
require 'rails_helper'

describe 'UploadCategories', class: CategoriesController do
  before(:all) do
    @root = Category.find_or_create_by(name: 'ROOT')
  end

  after(:all) do
    @root.delete
  end
  describe 'Upload' do
    context 'Successful upload' do
      it 'should import and report success' do
        expect do
          post '/api/categories/upload', params: {
            category_file: fixture_file_upload('files/categories/valid.xlsx')
          }
        end.to change(Category, :count).by 3
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => 'Categories imported.')
      end
    end

    context 'Headers Only' do
      it 'should import and report success' do
        expect do
          post '/api/categories/upload', params: {
            category_file: fixture_file_upload('files/categories/header.xlsx')
          }
        end.to_not change(Category, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => 'Categories imported.')
      end
    end

    context 'Empty File' do
      it 'should return an error' do
        expect do
          post '/api/categories/upload', params: {
            category_file: fixture_file_upload('files/categories/no_header.xlsx')
          }
        end.to_not change(Category, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => 'The sheet is empty.')
      end
    end

    context 'Missing Sheet' do
      it 'should return an error' do
        expect do
          post '/api/categories/upload', params: {
            category_file: fixture_file_upload('files/categories/no_sheet.xlsx')
          }
        end.to_not change(Category, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => 'The file must contain a sheet named Categories.')
      end
    end

    context 'Extra Columns' do
      it 'should return an error' do
        expect do
          post '/api/categories/upload', params: {
            category_file: fixture_file_upload('files/categories/extra_column.xlsx')
          }
        end.to_not change(Category, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' =>
          'The import sheet must contain these columns: Name, Parent')
      end
    end

    context 'Missing Columns' do
      it 'should return an error' do
        expect do
          post '/api/categories/upload', params: {
            category_file: fixture_file_upload('files/categories/missing_col.xlsx')
          }
        end.to_not change(Category, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' =>
          'The import sheet must contain these columns: Name, Parent')
      end
    end

    context 'Empty Row in Data' do
      it 'should return an error' do
        expect do
          post '/api/categories/upload', params: {
            category_file: fixture_file_upload('files/categories/empty_row.xlsx')
          }
        end.to_not change(Category, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => 'Blank field on row 3')
      end
    end

    context 'Nonexisting Parent' do
      it 'should return an error' do
        expect do
          post '/api/categories/upload', params: {
            category_file: fixture_file_upload('files/categories/nonexistant_parent.xlsx')
          }
        end.to_not change(Category, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => 'Unable to find parent category Birds on row 3')
      end
    end

    context 'Broken File (random bytes)' do
      it 'should return an error' do
        expect do
          post '/api/categories/upload', params: {
            category_file: fixture_file_upload('files/random.bin')
          }
        end.to_not change(Category, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => 'Unable to process - is this an xlsx/xls file?')
      end
    end
  end
end
