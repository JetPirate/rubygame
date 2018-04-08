# Represents a window
module Windows
  # Represents a window with settings
  class Settings < Gosu::Window
    def initialize
      super SettingsFile.get(:width), SettingsFile.get(:height)
      self.fullscreen = SettingsFile.get(:fullscreen)
      self.caption = 'Game settings'
      load_textures
      create_settings_buttons(settings_buttons_opts)
      create_settings_buttons_commands
    end

    def draw
      @background.draw(0, 0, ZOrder::BACKGROUND)
      @settings_buttons.map(&:draw)
    end

    def update
      update_settings_buttons
    end

    def needs_cursor?
      true
    end

    def button_down(id)
      return_menu if id == Gosu::KbEscape
    end

    def return_menu
      SettingsFile.save
      Game.load
      close
    end

    def toggle_music
      value = !SettingsFile.get(:music)
      SettingsFile.set(:music, value)
    end

    def toggle_fullscreen
      value = !SettingsFile.get(:fullscreen)
      SettingsFile.set(:fullscreen, value)
    end

    def save
      SettingsFile.save
    end

    def restart
      Game.reload
      close
    end

    private

    def load_textures
      @background = Textures.get(:sett_background)
    end

    def update_settings_buttons
      @settings_buttons.each do |button|
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

    def settings_buttons_opts
      {
        width: 150,
        height: 50,
        text: { value: ['BACK', 'TOGGLE MUSIC', 'TOGGLE FULLSCREEN', 'SAVE',
                        'RESTART GAME'],
                height: 25 }
      }
    end

    def create_settings_buttons(options)
      @settings_buttons = []
      y_offset = height * 0.25
      options[:text][:value].each do |name|
        options[:text][:value] = name
        @settings_buttons << UIElements::Button.new(self, width * 0.05,
                                                    y_offset,
                                                    options)
        y_offset += height * 0.1
      end
    end

    def create_settings_buttons_commands
      @settings_buttons.each do |button|
        button.create_command do
          case value
          when 'BACK'              then @window.return_menu
          when 'TOGGLE MUSIC'      then @window.toggle_music
          when 'TOGGLE FULLSCREEN' then @window.toggle_fullscreen
          when 'SAVE'              then @window.save
          when 'RESTART GAME'      then @window.restart
          end
        end
      end
    end
  end
end
