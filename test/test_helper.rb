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

serve_test_data
