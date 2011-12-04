require 'json'

class Parser
  def initialize(path)
    @path = path
  end

  def get_data
    json = read_file
    JSON.parse(json) rescue raise 'Invalid json format'
  end

  private
  def read_file
   if !File.exists?(@path) || !File.readable?(@path)
    raise 'File does not exist or its not readable'
   end
   File.open(@path, 'r').read rescue raise "Can't read the file #{@path}"
  end

end