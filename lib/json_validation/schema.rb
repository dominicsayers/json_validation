module JsonValidation
  class Schema
    extend Forwardable
    def_delegators :@schema_data, :keys, :fetch, :all?, :any?, :has_key?, :size

    attr_reader :schema_data, :base_uri, :fragment_elements, :resolution_scope

    def initialize(schema_data, base_uri = nil, resolution_scope = nil, fragment_elements = [])
      @schema_data = schema_data

      if base_uri
        @base_uri = Addressable::URI.parse(base_uri)
      else
        @base_uri = generate_base_uri
      end
      raise "base_uri has fragment" unless @base_uri.fragment.nil?

      if schema_data["id"] && schema_data["id"].is_a?(String)
        if resolution_scope
          @resolution_scope = resolution_scope.join(Addressable::URI.parse(schema_data["id"]))
        else
          @resolution_scope = Addressable::URI.parse(schema_data["id"])
        end
      else
        if resolution_scope
          @resolution_scope = resolution_scope
        else
          @resolution_scope = @base_uri
        end
      end

      @fragment_elements = fragment_elements
    end

    def generate_base_uri
      Addressable::URI.parse(Digest::SHA1.hexdigest(schema_data.to_json))
    end

    def uri
      if fragment_elements.empty?
        fragment = ""
      else
        fragment = "/" + fragment_elements.join("/")
      end
      Addressable::URI.new(base_uri.to_hash.merge(fragment: fragment))
    end

    def [](fragment)
      return self if fragment.nil?

      key, remainder = fragment.split("/", 2)

      if key == "" || key.nil?
        value = self
      else
        escaped_key = key.gsub('~0', '~').gsub('~1', '/').gsub('%25', '%')
        value = schema_data[escaped_key]
        if value.is_a?(Hash)
          value = Schema.new(value, base_uri, resolution_scope, fragment_elements + [key.to_s])
        elsif value.is_a?(Array) && value[0].is_a?(Hash)
          value = value.each_with_index.map {|v, ix|
            Schema.new(v, base_uri, resolution_scope, fragment_elements + [key.to_s] + [ix.to_s])
          }
        end
      end

      if remainder.nil?
        value
      else
        case value
        when Schema
          value[remainder]
        when Array
          value[remainder.to_i]
        else
          raise "Unexpected type for #{value}"
        end
      end
    end

    def map(&block)
      schema_data.map {|key, subschema|
        block.call(key, Schema.new(subschema, base_uri, resolution_scope, fragment_elements + [key]))
      }
    end
  end
end
