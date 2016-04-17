module JsonValidation
  class ValidationFailure < Struct.new(:schema_attribute)
  end
end
