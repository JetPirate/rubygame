module UIElements
  # Represents a button
  class Button < Label
    def initialize(window, x, y, options = {})
      super(window, x, y, options)
    end

    def create_command(&block)
      self.class.send(:define_method, :command, &block)
    end
  end
end
