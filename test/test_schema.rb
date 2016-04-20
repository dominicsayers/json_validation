require 'test_helper'

describe JsonValidation::Schema do
  describe "#initialize" do
    it "constructs base_uri if not present" do
      schema = JsonValidation::Schema.new({"type": "integer"})
      assert(!schema.base_uri.nil?)
    end
  end

  describe "#uri" do
    specify "with no fragment" do
      schema = JsonValidation::Schema.new({}, "http://localhost:1234/")
      assert_equal("http://localhost:1234/#", schema.uri.to_s)
    end

    specify "with fragment" do
      schema = JsonValidation::Schema.new({}, "http://localhost:1234/", nil, ["abc", "def"])
      assert_equal("http://localhost:1234/#/abc/def", schema.uri.to_s)
    end
  end

  describe "#resolution_scope" do
    # TODO
  end

  describe "#[]" do
    specify "looking up a simple value returns value" do
      schema = JsonValidation::Schema.new(
        {"type" => "integer"},
        "http://localhost:1234/",
      )

      assert_equal("integer", schema["type"])
    end

    describe "with subschemas" do
      before do
        @schema_data = {"properties" => {"a" => {"type" => "integer"}}}
        @schema = JsonValidation::Schema.new(@schema_data, "http://localhost:1234/")
      end

      specify "looking up a schema returns new Schema" do
        subschema = @schema["properties"]

        assert_equal(@schema_data["properties"], subschema.schema_data)
        assert_equal("http://localhost:1234/", subschema.base_uri.to_s)
        assert_equal("http://localhost:1234/#/properties", subschema.uri.to_s)
      end

      specify "looking up a schema with root fragment" do
        subschema = @schema["/"]

        assert_equal(@schema_data, subschema.schema_data)
        assert_equal("http://localhost:1234/", subschema.base_uri.to_s)
        assert_equal("http://localhost:1234/#", subschema.uri.to_s)
      end

      specify "looking up a schema with empty fragment" do
        subschema = @schema[""]

        assert_equal(@schema_data, subschema.schema_data)
        assert_equal("http://localhost:1234/", subschema.base_uri.to_s)
        assert_equal("http://localhost:1234/#", subschema.uri.to_s)
      end

      specify "looking up a schema by fragment" do
        subschema = @schema["/properties/a"]

        assert_equal(@schema_data["properties"]["a"], subschema.schema_data)
        assert_equal("http://localhost:1234/", subschema.base_uri.to_s)
        assert_equal("http://localhost:1234/#/properties/a", subschema.uri.to_s)
      end
    end

    describe "with escaped keys" do
      specify "with escaped tildes" do
        schema = JsonValidation::Schema.new(
          {"a~b" => {"c~d" => {"type": "integer"}}},
          "http://localhost:1234/",
        )
        subschema = schema["a~0b/c~0d"]

        assert_equal({"type": "integer"}, subschema.schema_data)
        assert_equal("http://localhost:1234/", subschema.base_uri.to_s)
        assert_equal("http://localhost:1234/#/a~0b/c~0d", subschema.uri.to_s)
      end

      specify "with escaped slashes" do
        schema = JsonValidation::Schema.new(
          {"a/b" => {"c/d" => {"type": "integer"}}},
          "http://localhost:1234/",
        )
        subschema = schema["a~1b/c~1d"]

        assert_equal({"type": "integer"}, subschema.schema_data)
        assert_equal("http://localhost:1234/", subschema.base_uri.to_s)
        assert_equal("http://localhost:1234/#/a~1b/c~1d", subschema.uri.to_s)
      end

      specify "with escaped percents" do
        schema = JsonValidation::Schema.new(
          {"a%b" => {"c%d" => {"type": "integer"}}},
          "http://localhost:1234/",
        )
        subschema = schema["a%25b/c%25d"]

        assert_equal({"type": "integer"}, subschema.schema_data)
        assert_equal("http://localhost:1234/", subschema.base_uri.to_s)
        assert_equal("http://localhost:1234/#/a%25b/c%25d", subschema.uri.to_s)
      end
    end
  end
end
