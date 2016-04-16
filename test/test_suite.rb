require 'test_helper'

base_path = File.join(File.dirname(__FILE__), 'json-schema-test-suite', 'tests', 'draft4')
test_paths = Dir[File.join(base_path, '*.json')] + Dir[File.join(base_path, 'optional', '*.json')]

test_paths.each do |path|
  describe File.basename(path, '.json') do
    next if File.basename(path, '.json') == 'format'

    test_groups = JSON.load(File.read(path))

    test_groups.each do |test_group|
      describe test_group['description'] do
        test_group['tests'].each do |test|
          before do
            @validator = JsonValidation.build_validator(test_group['schema'])
          end

          specify test['description'] do
            record = test['data']
            begin
              assert_equal(test["valid"], @validator.validate(record))

              if test["valid"]
                assert(@validator.validate_with_errors(record).empty?)
              else
                assert(!@validator.validate_with_errors(record).empty?)
              end
            rescue SocketError
              # We're not connected to the internet
              raise unless test_group['schema'] == {"$ref" => "http://json-schema.org/draft-04/schema#"}
              skip
            end
          end
        end
      end
    end
  end
end
