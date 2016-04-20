module JsonValidation
  class ValidationFailure < Struct.new(
    :schema,
    :schema_uri,
    :schema_attribute,
    :value,
    :value_path,
    :failures,
  )
    def initialize(hash)
      hash.each do |k, v|
        self[k] = v
      end
    end
  end
end
