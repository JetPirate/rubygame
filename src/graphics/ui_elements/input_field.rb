# frozen_string_literal: true

module UIElements
  # Represents an input field
  class InputField < Label
    attr_accessor :input

    def initialize(window, x, y, options = {})
      options[:image] ||= Textures.get(:default_input_field)
      super(window, x, y, options)
      @input = options[:input]
    end
  end
end
