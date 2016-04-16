require 'test_helper'

describe JsonValidation::SchemaValidator do
  describe "#validate_with_errors" do
    it "returns empty array for valid record" do
      schema = {"type" => "integer"}
      validator = JsonValidation.build_validator(schema)
      assert(validator.validate_with_errors(3).empty?)
    end

    it "returns error for each validation failure for invalid record" do
      schema = {"type" => "string", "minimum" => 10, "maximum" => 20}
      validator = JsonValidation.build_validator(schema)
      assert_equal(validator.validate_with_errors(3).size, 2)
    end
  end
end
