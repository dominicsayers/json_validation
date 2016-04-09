module JsonValidator
  module Validators
    module Ref
      extend self
      extend Validator

      type :any

      def validate(schema, fragment, record)
        path = fragment['$ref']

        if schema.uri.nil?
          reffed_uri = Addressable::URI.parse(path)
        else
          reffed_uri = Addressable::URI.parse(schema.uri).join(Addressable::URI.parse(path))
        end

        reffed_uri_fragment = reffed_uri.fragment
        reffed_uri.fragment = nil

        if reffed_uri.empty?
          reffed_schema = schema
        else
          reffed_schema = JsonValidator.load_schema(reffed_uri)
        end

        reffed_fragment = look_up_path(reffed_schema, reffed_uri_fragment)
        JsonValidator.validate(reffed_schema, reffed_fragment, record)
      end

      def look_up_path(schema, path)
        return schema if path == '' || path.nil?

        fragment = schema.data

        path[1..-1].split('/').each do |element|
          element = element.gsub('~0', '~').gsub('~1', '/').gsub('%25', '%')

          case fragment
          when Hash
            if fragment.has_key?(element)
              fragment = fragment[element]
              next
            end
          when Array
            begin
              ix = Integer(element)
              if ix < fragment.size
                fragment = fragment[ix]
                next
              end
            rescue ArgumentError
            end
          else
            raise "Could not look up #{path} in #{schema}"
          end
        end

        fragment
      end
    end
  end
end
