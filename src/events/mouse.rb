# frozen_string_literal: true

# Represents mouse events
module MouseEvents
  # States mouse can get into
  module MState
    UNDEF, IN, OUT, PRESSED, RELEASED, CLICKED = *0..4
  end

  def mouse_init_events
    @prev_mstate = MState::UNDEF
  end

  def mouse_pressed
    return unless mouse_in?
    return unless Gosu.button_down?(Gosu::MS_LEFT)
    return if @prev_mstate == MState::PRESSED
    yield self if block_given?
    @prev_mstate = MState::PRESSED
  end

  def mouse_released
    return unless mouse_in?
    return if Gosu.button_down?(Gosu::MS_LEFT) ||
              @prev_mstate == MState::RELEASED ||
              @prev_mstate != MState::PRESSED
    yield self if block_given?
    @prev_mstate = MState::RELEASED
  end

  def mouse_entered
    return unless mouse_in?
    return if @prev_mstate == MState::IN
    return unless @prev_mstate == MState::OUT || @prev_mstate == MState::UNDEF
    yield self if block_given?
    @prev_mstate = MState::IN
  end

  def mouse_exited
    return if mouse_in?
    return unless @prev_mstate == MState::IN
    yield self if block_given?
    @prev_mstate = MState::OUT
  end

  def mouse_clicked
    mouse_pressed
    return unless @prev_mstate == MState::PRESSED &&
                  !Gosu.button_down?(Gosu::MS_LEFT)
    yield self if block_given?
    @prev_mstate = MState::OUT
  end

  private

  def mouse_in?
    # OPTIMIZE: don't check every time
    if @x <= @window.mouse_x && @window.mouse_x <= @x + @width \
      && @y <= @window.mouse_y && @window.mouse_y <= @y + @height
      return true
    end
    false
  end
end
