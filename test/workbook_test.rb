require "./test/test_helper"

class WorkbookTest < Minitest::Test
  def test_open_filename
    @workbook = Xsv.open("test/files/office365-xl7.xlsx")

    refute_empty @workbook.sheets
  end

  def test_open_options
    @workbook = Xsv.open("test/files/office365-xl7.xlsx", trim_empty_rows: true)

    assert @workbook.trim_empty_rows
  end

  def test_open_buffer
    file = File.open("test/files/office365-xl7.xlsx")

    @workbook = Xsv.open(file)

    refute_empty @workbook.sheets
  end

  def test_open_string
    string = File.read("test/files/office365-xl7.xlsx")

    @workbook = Xsv.open(string)

    refute_empty @workbook.sheets
  end

  def test_open_tempfile
    t = Tempfile.new
    t.write(File.read("test/files/office365-xl7.xlsx"))
    t.rewind

    @workbook = Xsv.open(t)

    refute_empty @workbook.sheets
  end

  def test_legacy_open_filename
    @workbook = Xsv::Workbook.open("test/files/office365-xl7.xlsx")

    refute_empty @workbook.sheets
  end

  def test_legacy_open_options
    @workbook = Xsv::Workbook.open("test/files/office365-xl7.xlsx", trim_empty_rows: true)

    assert @workbook.trim_empty_rows
  end

  def test_legacy_open_block_syntax
    ret = Xsv::Workbook.open(File.open("test/files/office365-xl7.xlsx")) do |workbook|
      workbook.sheets.count
    end

    assert_equal 3, ret
  end

  def test_open_nonexisting
    assert_raises Zip::Error do
      @workbook = Xsv.open("does-not-exist.xlsx")
    end
  end

  def test_close
    @workbook = Xsv.open("test/files/office365-xl7.xlsx")

    @workbook.close
    assert_nil @workbook.sheets
  end

  def test_open_without_shared_strings
    @workbook = Xsv.open("test/files/no-shared-strings.xlsx")
    refute_empty @workbook.sheets
  end

  def test_new_instead_of_open
    assert_raises ArgumentError do
      Xsv::Workbook.new "not a Zip::File instance"
    end
  end

  def test_open_empty_file_from_buffer
    tempfile = Tempfile.new

    assert_raises Xsv::Error do
      @workbook = Xsv.open(tempfile)
    end
  end

  def test_open_empty_file_by_filename
    tempfile = Tempfile.new

    assert_raises Zip::Error do
      Xsv.open(tempfile.path)
    end
  end

  def test_inspect
    @workbook = Xsv.open("test/files/office365-xl7.xlsx")

    assert_match(/Xsv::Workbook/, @workbook.inspect)
  end
end
