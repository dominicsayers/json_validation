require 'test_helper'

describe "validation errors" do
  test_cases = JSON.load(File.read(File.join("test", "validation_errors.json")))
  test_cases.each do |test_case|
    specify test_case["description"] do
      validator = JsonValidation.build_validator(test_case["schema"])
      errors = validator.validate_with_errors(test_case["value"]).sort_by {|error|
        [error.schema_uri, error.schema_attribute]
      }

      assert_equal(errors.size, test_case["errors"].size, "Expected #{test_case["errors"].size} errors, got #{errors.size} errors")

      errors.zip(test_case["errors"]).each do |error, expected_error|
        assert_equal(expected_error["schema"], error.schema)
        assert_equal(expected_error["schema_uri"], error.schema_uri)
        assert_equal(expected_error["schema_attribute"], error.schema_attribute)
        assert_equal(expected_error["value"], error.value)
        # assert_equal(expected_error["value_path"], error.value_path)  TODO
      end
    end
  end
end
