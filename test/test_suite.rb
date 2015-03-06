require 'test_helper'

Dir[File.join(File.dirname(__FILE__), 'json-schema-test-suite', 'tests', 'draft4', '*.json')].each do |path|
  next if ['definitions', 'ref', 'refRemote'].include?(File.basename(path, '.json')) # XXX

  describe File.basename(path, '.json') do
    test_groups = JSON.load(File.read(path))

    test_groups.each do |test_group|
      describe test_group['description'] do
        test_group['tests'].each do |test|
          before do
            @schema = test_group['schema']
          end

          specify test['description'] do
            record = test['data']
            assert_equal(test['valid'], JsonValidator.validate(@schema, record))
          end
        end
      end
    end
  end
end
