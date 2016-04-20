require 'minitest/autorun'
# require 'minitest/reporters'
require 'mocha/mini_test'

require 'json_validation'

#Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

def serve_test_data
  require 'webrick'

  document_root = File.join(File.dirname(__FILE__), 'json-schema-test-suite', 'remotes')

  s = WEBrick::HTTPServer.new(
    Port: 1234,
    DocumentRoot: document_root,
    Logger: WEBrick::Log.new(File::NULL),
    AccessLog: [],
  )

  Thread.new {s.start}
end

def test_validation_failures(expected_errors, errors)
  errors = errors.sort_by {|error|
    [error.schema_uri.to_s, error.schema_attribute]
  }

  assert_equal(
    expected_errors.size,
    errors.size,
    "Expected #{expected_errors.size} errors, got #{errors.size} errors"
  )

  errors.zip(expected_errors).each do |error, expected_error|
    assert_equal(expected_error["schema"], error.schema.schema_data)
    assert_equal(expected_error["schema_uri"], error.schema_uri.to_s) if expected_error["schema_uri"]
    assert_equal(expected_error["schema_uri_fragment"], error.schema_uri.fragment) if expected_error["schema_uri_fragment"]
    assert_equal(expected_error["schema_attribute"], error.schema_attribute)
    assert_equal(expected_error["value"], error.value)
    assert_equal(expected_error["value_path"], error.value_path)

    expected_failures = expected_error["failures"]

    unless error.failures.nil? && expected_failures.nil?
      test_validation_failures(expected_failures, error.failures)
    end
  end
end

serve_test_data
