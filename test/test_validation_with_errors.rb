require 'test_helper'

test_paths = Dir[File.join(File.dirname(__FILE__), 'validation_errors', '*.json')]

describe "validation errors" do
  test_paths.each do |path|
    describe File.basename(path, ".json") do
      test_cases = JSON.load(File.read(path))
      test_cases.each do |test_case|
        specify test_case["description"] do
          validator = JsonValidation.build_validator(test_case["schema"])
          errors = validator.validate_with_errors(test_case["value"])
          test_validation_failures(test_case["errors"], errors)
        end
      end
    end
  end
end
