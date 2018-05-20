module UIElements
  # Represents a button
  class Button < Label
    def initialize(window, x, y, options = {})
      super(window, x, y, options)
    end

    def create_command(&block)
      self.class.send(:define_method, :command, &block)
    end

    def refresh
      yield self if block_given?
    end

    protected

    def parse(options = {})
      super(options)
      @command_name = options[:command][:name]
    end
  end
end
