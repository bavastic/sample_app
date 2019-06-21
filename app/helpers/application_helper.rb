# frozen_string_literal: true

module ApplicationHelper
  # TODO: Split this up into several methods.
  def validate_spreadsheet(spreadsheet, col_names, sheet_name)
    error, uploaded_file = load_sheet(spreadsheet)
    return error, nil if error.present?
    return "The file must contain a sheet named #{sheet_name}.", nil unless uploaded_file.sheets == [sheet_name]

    sheet = uploaded_file.sheet(sheet_name)
    error, sheet = check_columns(sheet, col_names)
    return error, nil if error.present?

    # Everything about the file metadata is fine, so let's return this.
    [nil, sheet]
  end

  private

  def load_sheet(file)
    begin
      uploaded_file = Roo::Spreadsheet.open(file)
    rescue ArgumentError # Roo raises an ArgumentError if it can't detect the format
      return 'Unable to process - is this an xlsx/xls file?', nil
    end
    [nil, uploaded_file]
  end

  def check_columns(sheet, col_names)
    unless sheet.row(1) == col_names
      return ["The import sheet must contain these columns: #{col_names.join(', ')}",
              nil]
    end

    [nil, sheet]
  rescue NoMethodError # Trying to access row 1 on a 0 row spreadsheet
    ['The sheet is empty.', nil]
  end
end
