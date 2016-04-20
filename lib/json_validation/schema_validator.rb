module JsonValidation
  class SchemaValidator
    attr_reader :schema

    def initialize(schema)
      @schema = schema
    end

    def validate(record, record_path = nil)
      record_path ||= ["#"]
      validators_for_record(record).all? {|validator|
        validator.validate(record, record_path)
      }
    end

    def validate_with_errors(record, record_path = nil)
      record_path ||= ["#"]
      validators_for_record(record).map {|validator|
        validator.validate_with_errors(record, record_path)
      }.flatten.compact
    end

    def validators_for_record(record)
      validators.select {|validator|
        TYPES_TO_CLASSES[validator.class.type].any? {|klass| record.is_a?(klass)}
      }
    end

    def validators
      return @validators unless @validators.nil?
      @validators = schema.keys.map {|key|
        if key == '$ref'
          validator_name = 'Ref'
        else
          validator_name = key[0].upcase + key[1..-1]
        end

        begin
          klass = JsonValidation::Validators.const_get(:"#{validator_name}")
        rescue NameError
          nil
        else
          klass.new(schema)
        end
      }.compact
    end
  end
end
