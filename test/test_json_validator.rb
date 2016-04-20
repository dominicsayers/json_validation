require 'test_helper'

describe JsonValidation do
  describe '.load_validator' do
    it 'accepts a String' do
      uri = 'http://localhost:1234/integer.json'
      validator = JsonValidation.load_validator(uri)
      assert(validator.validate(3))
    end

    it 'accepts an Addressable::URI' do
      uri = Addressable::URI.parse('http://localhost:1234/integer.json')
      validator = JsonValidation.load_validator(uri)
      assert(validator.validate(3))
    end
  end

  describe '.build_validator' do
    it 'accepts a hash' do
      schema = {'type' => 'integer'}
      validator = JsonValidation.build_validator(schema)
      assert(validator.validate(3))
    end

    it 'accepts a hash and a String uri' do
      schema = {'type' => 'integer'}
      uri = 'http://localhost:1234/schema.json'
      validator = JsonValidation.build_validator(schema, uri: uri)
      assert(validator.validate(3))
      assert_equal(uri, validator.schema.base_uri.to_s)
    end

    it 'accepts a hash and an Addressable::URI uri' do
      schema = {'type' => 'integer'}
      uri = Addressable::URI.parse('http://localhost:1234/schema.json')
      validator = JsonValidation.build_validator(schema, uri: uri)
      assert(validator.validate(3))
      assert_equal(uri, validator.schema.base_uri)
    end

    it 'accepts a Schema' do
      schema = JsonValidation::Schema.new({'type' => 'integer'})
      validator = JsonValidation.build_validator(schema)
      assert(validator.validate(3))
    end

    it 'raises exception if called with Schema and a uri' do
      schema = JsonValidation::Schema.new({'type' => 'integer'})
      assert_raises(ArgumentError) do
        JsonValidation.build_validator(schema, uri: 'http://localhost:1234/schema.json')
      end
    end
  end

  describe '.load_schema' do
    before do
      JsonValidation.clear_schema_cache
    end

    after do
      JsonValidation.clear_schema_cache
    end

    it 'can load schema on filesystem' do
      path = File.join(File.dirname(__FILE__), 'schemas', 'integer.json')
      uri = Addressable::URI.parse(path)
      schema = JsonValidation.load_schema(uri)
      assert_equal({'type' => 'integer'}, schema.schema_data)
      assert_equal(uri, schema.uri)
      assert_equal(uri, schema.base_uri)
    end

    it 'can load schema via HTTP' do
      uri = Addressable::URI.parse('http://localhost:1234/integer.json')
      schema = JsonValidation.load_schema(uri)
      assert_equal({'type' => 'integer'}, schema.schema_data)
      assert_equal(uri, schema.uri)
      assert_equal(uri, schema.base_uri)
    end

    it 'can load schema when URI has fragment' do
      uri = Addressable::URI.parse('http://localhost:1234/subSchemas.json#/integer')
      base_uri = Addressable::URI.parse('http://localhost:1234/subSchemas.json')
      schema = JsonValidation.load_schema(uri)
      assert_equal({'type' => 'integer'}, schema.schema_data)
      assert_equal(uri, schema.uri)
      assert_equal(base_uri, schema.base_uri)
    end

    it 'caches schema' do
      JSON.expects(:parse).once.returns({})

      uri = Addressable::URI.parse('http://localhost:1234/integer.json')
      JsonValidation.load_schema(uri)
      JsonValidation.load_schema(uri)
    end
  end
end
