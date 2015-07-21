module JsonValidator
  class Schema
    extend Forwardable
    def_delegators :@data, :[], :fetch, :keys, :has_key?

    attr_reader :data

    def initialize(data, uri)
      @data = data
      @uri = uri
    end
  end
end
