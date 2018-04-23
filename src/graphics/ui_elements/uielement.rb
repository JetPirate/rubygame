# Represents GUI elements
module UIElements
  # Represents an ui element
  class UIElement
    include Resources::Colors

    attr_reader :x, :y, :z, :width, :height, :window

    def initialize(window, x, y, options = {})
      @window = window
      @x = x
      @y = y
      @z = options[:z] || ZOrder::UI
      parse(options)
    end

    protected

    def draw(*)
      raise NotImplementedError
    end

    def update(*)
      raise NotImplementedError
    end

    def parse(_options)
      raise NotImplementedError
    end
  end
end
