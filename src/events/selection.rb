# frozen_string_literal: true

# Represents selection events
module SelectionEvents
  def selected=(value)
    @on_select&.call(self) if value == true && !selected?
    @off_select&.call(self) if value == false && selected?
    @selected = value
  end

  def selected?
    @selected
  end

  def on_select(&block)
    @on_select = block
  end

  def off_select(&block)
    @off_select = block
  end
end
