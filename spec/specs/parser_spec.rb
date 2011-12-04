require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Parser do

  describe "#get_data" do
    it "returns an array of hashes from a given json" do
      parser = Parser.new("path")
      parser.stub(:read_file).and_return('[{"id":0,"name": "John"}, {"id":1,"name": "Simon"}]')
      data = parser.get_data
      data.class === Array
      data.first.class === Hash
    end

    it "raises an error when try to read a file that does not exist" do
      parser = Parser.new('file/that/does/not/exist')
      lambda{parser.get_data}.should raise_error(RuntimeError, 'File does not exist or its not readable')
    end

    it "raises an error if unable to parse json properly" do
      parser = Parser.new('path')
      parser.stub(:read_file).and_return('definitely not a json format')
      lambda{parser.get_data}.should raise_error(RuntimeError, 'Invalid json format')
    end
  end
end