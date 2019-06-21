# frozen_string_literal: true
require 'rails_helper'

describe 'UploadProducts', class: ProductsController do
  before(:all) do
    @root = Category.find_or_create_by(name: 'ROOT')
    @figurines = Category.find_or_create_by(name: 'Figurines')
    @penguin_figurines = Category.find_or_create_by(name: 'Penguin Figurines', parent: @figurines)
    @walrus_figurines = Category.find_or_create_by(name: 'Walrus Figurines', parent: @figurines)
  end

  after(:all) do
    Product.delete_all
    Category.delete_all
  end

  describe 'Upload' do
    context 'Successful upload' do
      it 'should import and report success' do
        expect do
          post '/api/products/upload', params: {
            product_file: fixture_file_upload('files/products/valid.xlsx')
          }
        end.to change(Product, :count).by 5
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => nil)
      end
    end

    context 'Headers only' do
      it 'should import and report success' do
        expect do
          post '/api/products/upload', params: {
            product_file: fixture_file_upload('files/products/header.xlsx')
          }
        end.to_not change(Product, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => nil)
      end
    end

    context 'Empty File' do
      it 'should return an error' do
        expect do
          post '/api/products/upload', params: {
            product_file: fixture_file_upload('files/products/no_header.xlsx')
          }
        end.to_not change(Product, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => 'The sheet is empty.')
      end
    end

    context 'Missing Sheet' do
      it 'should return an error' do
        expect do
          post '/api/products/upload', params: {
            product_file: fixture_file_upload('files/products/no_sheet.xlsx')
          }
        end.to_not change(Product, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => 'The file must contain a sheet named Products.')
      end
    end

    context 'Extra Columns' do
      it 'should return an error' do
        expect do
          post '/api/products/upload', params: {
            product_file: fixture_file_upload('files/products/extra_column.xlsx')
          }
        end.to_not change(Product, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' =>
          'The import sheet must contain these columns: Name, Category, Price, Currency, DisplayCurrency')
      end
    end

    context 'Missing Columns' do
      it 'should return an error' do
        expect do
          post '/api/products/upload', params: {
            product_file: fixture_file_upload('files/products/missing_col.xlsx')
          }
        end.to_not change(Product, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' =>
          'The import sheet must contain these columns: Name, Category, Price, Currency, DisplayCurrency')
      end
    end

    context 'Empty Row in Data' do
      it 'should return an error' do
        expect do
          post '/api/products/upload', params: {
            product_file: fixture_file_upload('files/products/empty_row.xlsx')
          }
        end.to_not change(Product, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => 'Blank field on row 3')
      end
    end

    context 'Nonexisting Parent' do
      it 'should return an error' do
        expect do
          post '/api/products/upload', params: {
            product_file: fixture_file_upload('files/products/nonexistant_category.xlsx')
          }
        end.to_not change(Product, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => 'Unable to find category Animals on row 5')
      end
    end

    context 'Broken File (random bytes)' do
      it 'should return an error' do
        expect do
          post '/api/products/upload', params: {
            product_file: fixture_file_upload('files/random.bin')
          }
        end.to_not change(Product, :count)
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq('message' => 'Unable to process - is this an xlsx/xls file?')
      end
    end
  end
end
