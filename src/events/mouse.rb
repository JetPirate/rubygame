# Represents mouse events
module MouseEvents
  attr_accessor :press_captured, :release_captured

  @press_captured = false
  @release_captured = false

  def mouse_pressed
    return unless mouse_in?
    return unless Gosu.button_down?(Gosu::MS_LEFT)
    return if @press_captured
    yield self
    @press_captured = true
    @release_captured = false
  end

  def mouse_released
    return unless @press_captured
    return unless mouse_in?
    return if Gosu.button_down?(Gosu::MS_LEFT)
    return if @release_captured
    yield self
    @release_captured = true
    @press_captured = false
  end

  def mouse_entered
    return unless mouse_in?
    yield self
  end

  def mouse_exited
    return if mouse_in?
    yield self
  end

  def mouse_clicked
    raise NotImplementedError
  end

  private

  def mouse_in?
    # OPTIMIZE: don't check every time
    if @x <= @window.mouse_x && @window.mouse_x <= @x + @width \
      && @y <= @window.mouse_y && @window.mouse_y <= @y + @height
      true
    end
  end
end
