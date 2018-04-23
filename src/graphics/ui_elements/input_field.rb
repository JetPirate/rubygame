module UIElements
  # Represents an input field
  class InputField < Label
    def initialize(window, x, y, options = {})
      super(window, x, y, options)
    end

    def draw(*); end

    def update(*); end

    private

    def parse(_options); end
  end
end
