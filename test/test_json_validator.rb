require 'test_helper'

describe JsonValidator do
  describe '.load_schema' do
    it 'can load schema on filesystem' do
      path = File.join(File.dirname(__FILE__), 'schemas', 'integer.json')
      uri = Addressable::URI.parse(path)
      assert_equal({'type' => 'integer'}, JsonValidator.load_schema(uri).data)
    end

    it 'can load schema at URL' do
      uri = Addressable::URI.parse('http://localhost:1234/integer.json')
      assert_equal({'type' => 'integer'}, JsonValidator.load_schema(uri).data)
    end

    describe 'caching' do
      before do
        begin
          JsonValidator.send(:remove_instance_variable, :@schema_cache)
        rescue NameError
        end

        after do
          JsonValidator.send(:remove_instance_variable, :@schema_cache)
        end

        it 'caches schema' do
          JSON.expects(:parse).once

          path = File.join(File.dirname(__FILE__), 'schemas', 'integer.json')
          uri = Addressable::URI.parse('http://localhost:1234/integer.json')
          JsonValidator.load_schema(uri)
          JsonValidator.load_schema(uri)
        end
      end
    end
  end
end
