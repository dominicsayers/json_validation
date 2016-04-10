module JsonValidator
  class ValidatorCollection
    def initialize(validators)
      @validators = validators
    end

    def validate(record)
      @validators.all? {|validator|
        if TYPES_TO_CLASSES[validator.class.type].any? {|klass| record.is_a?(klass)}
          validator.validate(record)
        else
          true
        end
      }
    end
  end
end
