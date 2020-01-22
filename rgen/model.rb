module Rgen
  class Model
    attr_reader :name, :attributes, :belong_tos

    def initialize(name)
      @name = name
      @attributes = []
      @belong_tos = []
    end
  end
end
