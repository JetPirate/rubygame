# Represents game windows
module Windows
  # Represents a menu window
  class Menu < Gosu::Window
    def initialize(options = {})
      super options[:width] || 640, options[:height] || 480
      self.fullscreen = options[:fullscreen] || false
      self.caption = options[:caption] || 'Press Enter'
      load_textures
      create_menu_buttons(menu_buttons_opts)
      create_menu_buttons_commands
      set_music
    end

    def draw
      @background.draw(0, 0, ZOrder::BACKGROUND)
      draw_menu_buttons
      draw_controls if @show_controls
    end

    def update
      update_menu_buttons
    end

    def button_down(id)
      start_game if id == Gosu::KbReturn
      toggle_fullscreen if id == Gosu::KbH
      toggle_controls if id == Gosu::KbC
      close if id == Gosu::KbEscape
    end

    def needs_cursor?
      true
    end

    def start_game
      Game.start(
        width: width,
        height: height,
        fullscreen: fullscreen?
      )
      close
    end

    def exit_game
      Game.end
      close
    end

    def settings
      # TODO
    end

    def toggle_controls
      @show_controls ||= false
      @show_controls = !@show_controls
    end

    private

    def load_textures
      @background = Textures.get(:background_menu)
      @controls_page = Textures.get(:controls)
    end

    def set_music
      @music = Sounds.get(:menu_music)
      @music.volume = 0.5
      @music.play(true)
    end

    def create_menu_buttons(options)
      @menu_buttons = []
      y_offset = height * 0.25
      options[:text][:value].each do |name|
        options[:text][:value] = name
        @menu_buttons << UIElements::Button.new(self,
                                                width * 0.05,
                                                y_offset,
                                                options)
        y_offset += height * 0.1
      end
    end

    def draw_menu_buttons
      @menu_buttons.map(&:draw)
    end

    def draw_controls
      @controls_page.draw(0, 0, ZOrder::UI)
    end

    def update_menu_buttons
      @menu_buttons.each do |button|
        button.mouse_entered do |this|
          this.color = 0xff_e7_6f_0d
        end
        button.mouse_exited do |this|
          this.color = 0xff_ff_ff_ff
        end
        button.mouse_pressed(&:command)
        button.mouse_released { ; }
      end
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

    def menu_buttons_opts
      {
        width: 150,
        height: 50,
        text: { value: %w[NEW SETTINGS CONTROLS EXIT],
                height: 25 }
      }
    end

    def create_menu_buttons_commands
      @menu_buttons.each do |button|
        button.create_command do
          case value
          when 'NEW'      then @window.start_game
          when 'SETTINGS' then @window.settings
          when 'CONTROLS' then @window.toggle_controls
          when 'EXIT'     then @window.exit_game
          end
        end
      end
    end
  end
end
