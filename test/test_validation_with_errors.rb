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

    it "collects failing schema attribute for each error" do
      schema = {"type" => "string", "minimum" => 10, "maximum" => 20}
      validator = JsonValidation.build_validator(schema)
      errors = validator.validate_with_errors(3)
      schema_attributes = errors.map(&:schema_attribute).sort
      assert_equal(schema_attributes, ["minimum", "type"])
    end

    describe "properties" do
      it "collects failing schema attribute for each error" do
        schema = {
          "properties" => {
            "a" => {
              "type" => "string",
              "minimum" => 10,
              "maximum" => 20
            }
          }
        }

        validator = JsonValidation.build_validator(schema)
        errors = validator.validate_with_errors({"a" => 3})
        schema_attributes = errors.map(&:schema_attribute).sort
        assert_equal(schema_attributes, ["minimum", "type"])
      end
    end

    describe "nested properties" do
      it "collects failing schema attribute for each error" do
        schema = {
          "properties" => {
            "a" => {
              "properties" => {
                "b" => {
                  "type" => "string",
                  "minimum" => 10,
                  "maximum" => 20
                }
              }
            }
          }
        }

        validator = JsonValidation.build_validator(schema)
        errors = validator.validate_with_errors({"a" => {"b" => 3}})
        schema_attributes = errors.map(&:schema_attribute).sort
        assert_equal(schema_attributes, ["minimum", "type"])
      end
    end

    describe "patternProperties" do
      it "collects failing schema attribute for each error" do
        schema = {
          "patternProperties" => {
            "ab?" => {
              "type" => "string",
              "minimum" => 10,
              "maximum" => 20
            }
          }
        }

        validator = JsonValidation.build_validator(schema)
        errors = validator.validate_with_errors({"a" => 3})
        schema_attributes = errors.map(&:schema_attribute).sort
        assert_equal(schema_attributes, ["minimum", "type"])
      end
    end
  end
end
