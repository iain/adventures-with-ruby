require 'singleton'

class Archive < Array
  include Singleton

  def initialize(*)
    replace IndexReader.read.values
  end

end
