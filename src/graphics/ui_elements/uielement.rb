# frozen_string_literal: true

# Represents GUI elements
module UIElements
  # Represents an ui element
  class UIElement
    include Resources::Colors

    attr_reader :x, :y, :z, :width, :height, :window
    attr_accessor :extensions

    def initialize(window, x, y, options = {})
      @window = window
      @x = x
      @y = y
      @z = options[:z] || ZOrder::UI
      @extensions = options[:extensions] || {}
      parse(options)
    end

    def draw(*)
      raise NotImplementedError
    end

    def update(*)
      raise NotImplementedError
    end

    protected

    def parse(_options)
      raise NotImplementedError
    end
  end
end
