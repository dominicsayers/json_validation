require 'test_helper'

test_paths = Dir[File.join(File.dirname(__FILE__), 'validation_errors', '*.json')]

describe "validation errors" do
  test_paths.each do |path|
    describe File.basename(path, ".json") do
      test_cases = JSON.load(File.read(path))
      test_cases.each do |test_case|
        specify test_case["description"] do
          validator = JsonValidation.build_validator(test_case["schema"])
          errors = validator.validate_with_errors(test_case["value"]).sort_by {|error|
            [error.schema_uri.to_s, error.schema_attribute]
          }

          assert_equal(test_case["errors"].size, errors.size, "Expected #{test_case["errors"].size} errors, got #{errors.size} errors")

          errors.zip(test_case["errors"]).each do |error, expected_error|
            assert_equal(expected_error["schema"], error.schema.schema_data)
            assert_equal(expected_error["schema_uri"], error.schema_uri.to_s) if expected_error["schema_uri"]
            assert_equal(expected_error["schema_uri_fragment"], error.schema_uri.fragment) if expected_error["schema_uri_fragment"]
            assert_equal(expected_error["schema_attribute"], error.schema_attribute)
            assert_equal(expected_error["value"], error.value)
            assert_equal(expected_error["value_path"], error.value_path)
          end
        end
      end
    end
  end
end
