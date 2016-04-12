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
      assert_equal({'type' => 'integer'}, JsonValidation.load_schema(uri))
    end

    it 'can load schema via HTTP' do
      uri = Addressable::URI.parse('http://localhost:1234/integer.json')
      assert_equal({'type' => 'integer'}, JsonValidation.load_schema(uri))
    end

    it 'can load schema when URI has fragment' do
      uri = Addressable::URI.parse('http://localhost:1234/subSchemas.json#/integer')
      assert_equal({'type' => 'integer'}, JsonValidation.load_schema(uri))
    end

    it 'caches schema' do
      JSON.expects(:parse).once

      uri = Addressable::URI.parse('http://localhost:1234/integer.json')
      JsonValidation.load_schema(uri)
      JsonValidation.load_schema(uri)
    end
  end
end
