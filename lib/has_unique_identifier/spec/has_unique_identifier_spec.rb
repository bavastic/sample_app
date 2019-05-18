# frozen_string_literal: true

RSpec.describe HasUniqueIdentifier do
  let(:mock_class) { build_mock_class }

  before(:all) { create_table }
  after(:all) { drop_table }

  describe '.create' do
    it 'sets the identity attributes with the specified format' do
      record = mock_class.create
      expect(record.some_identifier).to match(/^[A-Z]{4}:[A-Z]{4}$/)
      expect(record.other_identifier).to match(/^[A-Z]{2}-[A-Z]{2}-[A-Z]{2}$/)
    end

    it 'sets create values that are unique within the class' do
      mock_class.create
      # the creation of a second record would already cause fail if
      # the values were not unique because of the db constraints
      mock_class.create
    end
  end

  def build_mock_class
    Class.new(ActiveRecord::Base) do
      self.table_name = 'mock_table'
      has_unique_identifier :some_identifier, segment_count: 2, segment_size: 4, delimiter: ':'
      has_unique_identifier :other_identifier, segment_count: 3, segment_size: 2, delimiter: '-'
    end
  end

  def create_table
    ActiveRecord::Base.connection.create_table :mock_table do |t|
      t.string :some_identifier
      t.string :other_identifier
    end
    ActiveRecord::Base.connection.add_index :mock_table, :some_identifier, unique: true
    ActiveRecord::Base.connection.add_index :mock_table, :other_identifier, unique: true
  end

  def drop_table
    ActiveRecord::Base.connection.drop_table :mock_table
  end
end
