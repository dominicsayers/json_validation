require 'test_helper'

class DateTimeFormatValidator
  def validate(value, value_path)
    Date.parse(value)
    true
  rescue ArgumentError
    false
  end
end


describe "format validation" do
  before do
    JsonValidation.add_format_validator("date-time", DateTimeFormatValidator)
  end

  after do
    JsonValidation.clear_format_validators
  end

  it "validates format" do
    path = File.join(File.dirname(__FILE__), 'json-schema-test-suite', 'tests', 'draft4', 'optional', 'format.json')
    test_groups = JSON.load(File.read(path))
    test_group = test_groups.detect {|group| group['description'] == 'validation of date-time strings'}

    validator = JsonValidation.build_validator(
      test_group['schema'],
      strict_format_validation: true
    )

    test_group['tests'].each do |test|
      record = test['data']
      assert_equal(test["valid"], validator.validate(record))
    end
  end
end
