require 'ckwconfig/validator'
require 'ckwconfig/schema'
require 'ckwconfig/dumper'
require 'yaml'
require 'kwalify'
require 'stringio'

class CkwConfig
  class ValidationMultiError < Kwalify::ValidationError
    def errors
      @errors ||= []
    end
  end

  def self.load_file(filename)
    compile YAML.load_file(filename)
  end

  def self.load(yaml)
    compile YAML.load(yaml)
  end

  def self.compile(data)
    errors = validator.validate(data)
    case
    when errors.empty?
      new data
    when errors.size < 1
      raise errors.first
    else
      e = ValidationMultiError.new
      e.errors.concat errors
      e.errors.freeze
      raise e
    end
  end

  def self.schema
    @schema ||= Schema.define
  end

  def self.validator
    @validator ||= Validator.new(schema)
  end

  def initialize(table)
    @table = table
  end

  def dump(output = nil)
    f = (output || StringIO.new)
    Dumper.dump @table, f
    output or f.string
  end
end

