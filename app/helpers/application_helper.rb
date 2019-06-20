# frozen_string_literal: true

module ApplicationHelper
  # TODO: Split this up into several methods.
  def validate_spreadsheet(spreadsheet, col_names, sheet_name)
    Rails.logger.info 'Validating...'
    Rails.logger.info spreadsheet.inspect
    begin
      uploaded_file = Roo::Spreadsheet.open(spreadsheet)
    rescue ArgumentError # Roo raises an ArgumentError if it can't detect the format
      return 'Unable to process - is this an xlsx/xls file?', nil
    end
    return "The file must contain a sheet named #{sheet_name}.", nil unless uploaded_file.sheets == [sheet_name]

    sheet = uploaded_file.sheet(sheet_name)
    begin
      unless sheet.row(1) == col_names
        return "The category sheet must contain two columns: #{col_names.join(', ')}", nil
      end
    rescue NoMethodError # Trying to access row 1 on a 0 row spreadsheet
      return 'The sheet is empty.', nil
    end
    # Everything about the file metadata is fine, so let's return this.
    [nil, sheet]
  end
end
