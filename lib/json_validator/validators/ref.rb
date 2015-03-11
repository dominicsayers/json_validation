module JsonValidator
  module Validators
    module Ref
      extend self
      extend Validator

      type :any

      def validate(schema, fragment, record)
        path = fragment['$ref']
        uri = Addressable::URI.parse(path)

        uri_fragment = uri.fragment

        if uri.host.nil?
          reffed_schema = schema
        else
          uri.fragment = ''
          reffed_schema = JSON.parse(open(uri).read)
        end

        reffed_fragment = look_up_path(reffed_schema, uri_fragment)
        JsonValidator.validate(reffed_schema, reffed_fragment, record)
      end

      def look_up_path(schema, path)
        return schema if path == '' || path.nil?

        fragment = schema

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
          end

          raise "Could not look up #{path} in #{schema}"
        end

        fragment
      end
    end
  end
end
