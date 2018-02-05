# Represents game windows
module Windows
  # Represents a menu window
  class Menu < Gosu::Window
    def initialize(options = {})
      super options[:width] || 640, options[:height] || 480
      self.fullscreen = options[:fullscreen] || false
      self.caption = options[:caption] || 'Press Enter'
      load_textures
      # create_menu_buttons(%w[NEW SETTINGS CONTROLS EXIT])
    end

    def draw
      @background.draw(0, 0, ZOrder::BACKGROUND)
      # draw_menu_buttons(x: width * 0.05, y: height * 0.25)
    end

    def button_down(id)
      start_game if id == Gosu::KbReturn
      toggle_fullscreen if id == Gosu::KbH
      close if id == Gosu::KbEscape
    end

    def needs_cursor?
      true
    end

    private

    def load_textures
      @background = Textures.get(:background_menu)
    end

    def create_menu_buttons(names = [])
      @menu_buttons = []
      names.each do |name|
        @menu_buttons << Gosu::Image.from_text(name, 20)
      end
    end

    def draw_menu_buttons(options = {})
      # @menu_buttons.each do |button|
      #   color = if Gosu.distance(options[:x], options[:y], mouse_x, mouse_y) < 20
      #             color = Gosu::Color.new(0xff_00_00_00)
      #             color.red = rand(256 - 40) + 40
      #             color.green = rand(256 - 40) + 40
      #             color.blue = rand(256 - 40) + 40
      #             color
      #           else
      #             0xff_ff_ff_ff
      #           end
      #   button.draw(options[:x], options[:y], ZOrder::UI, 1.0, 1.0, color)
      #   options[:y] += 50
      # end
    end

    def start_game
      Game.start(
        width: width,
        height: height,
        fullscreen: fullscreen?
      )
      close
    end

    def toggle_fullscreen
      self.fullscreen = fullscreen? ? false : true
      Game.reload(
        width: fullscreen? ? Gosu.screen_width : nil,
        height: fullscreen? ? Gosu.screen_height : nil,
        fullscreen: fullscreen?
      )
      close
    end
  end
end
