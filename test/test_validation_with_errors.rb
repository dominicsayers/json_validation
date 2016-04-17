require 'test_helper'

describe JsonValidation::SchemaValidator do
  describe "#validate_with_errors" do
    it "returns empty array for valid record" do
      schema = {"type" => "integer"}
      validator = JsonValidation.build_validator(schema)
      assert(validator.validate_with_errors(3).empty?)
    end

    describe "simple value" do
      before do
        schema = {"type" => "string", "minimum" => 10, "maximum" => 20}
        validator = JsonValidation.build_validator(schema)
        @errors = validator.validate_with_errors(3)
      end

      it "returns error for each validation failure for invalid record" do
        assert_equal(@errors.size, 2)
      end

      it "collects failing schema for each error" do
        schemas = @errors.map(&:schema)
        schema = {"type" => "string", "minimum" => 10, "maximum" => 20}
        assert_equal(schemas, [schema, schema])
      end

      it "collects failing schema uri for each error" do
        schema_uris = @errors.map(&:schema_uri)
        assert_equal(schema_uris, ["#/", "#/"])
      end

      it "collects failing value for each error" do
        values = @errors.map(&:value)
        assert_equal(values, [3, 3])
      end

      it "collects failing schema attribute for each error" do
        schema_attributes = @errors.map(&:schema_attribute).sort
        assert_equal(schema_attributes, ["minimum", "type"])
      end
    end

    describe "properties" do
      before do
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
        @errors = validator.validate_with_errors({"a" => 3})
      end

      it "collects failing schema attribute for each error" do
        schema_attributes = @errors.map(&:schema_attribute).sort
        assert_equal(schema_attributes, ["minimum", "type"])
      end

      it "collects failing schema for each error" do
        schemas = @errors.map(&:schema)
        schema = {"type" => "string", "minimum" => 10, "maximum" => 20}
        assert_equal(schemas, [schema, schema])
      end

      it "collects failing schema uri for each error" do
        schema_uris = @errors.map(&:schema_uri)
        assert_equal(schema_uris, ["#/properties/a", "#/properties/a"])
      end

      it "collects failing value for each error" do
        values = @errors.map(&:value)
        assert_equal(values, [3, 3])
      end
    end

    describe "nested properties" do
      before do
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
        @errors = validator.validate_with_errors({"a" => {"b" => 3}})
      end

      it "collects failing schema attribute for each error" do
        schema_attributes = @errors.map(&:schema_attribute).sort
        assert_equal(schema_attributes, ["minimum", "type"])
      end

      it "collects failing schema for each error" do
        schemas = @errors.map(&:schema)
        schema = {"type" => "string", "minimum" => 10, "maximum" => 20}
        assert_equal(schemas, [schema, schema])
      end

      it "collects failing schema uri for each error" do
        schema_uris = @errors.map(&:schema_uri)
        assert_equal(schema_uris, ["#/properties/a/properties/b", "#/properties/a/properties/b"])
      end

      it "collects failing value for each error" do
        values = @errors.map(&:value)
        assert_equal(values, [3, 3])
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
