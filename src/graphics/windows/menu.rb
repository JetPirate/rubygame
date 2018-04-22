require_relative '../resources'
require_relative 'states'
# Represents game windows
module Windows
  # Represents a menu window
  # rubocop:disable ClassLength
  class Menu < Gosu::Window
    include Resources
    include States
    def initialize
      super SettingsFile.get(:width), SettingsFile.get(:height)
      load_defaults
      load_settings
      load_controls
      load_music
      @state = MENU
    end

    def draw
      case @state
      when MENU     then draw_menu
      when SETTINGS then draw_settings
      when CONTROLS then draw_controls
      end
    end

    def update
      case @state
      when MENU     then update_menu
      when SETTINGS then update_settings
      when CONTROLS then update_controls
      end
    end

    def button_down(id)
      start_game if id == Gosu::KbReturn
      show_settings if id == Gosu::KbS
      show_controls if id == Gosu::KbC
      close if id == Gosu::KbEscape
    end

    def needs_cursor?
      true
    end

    def start_game
      Game.start
      close
    end

    def exit_game
      Game.end
      close
    end

    def show_settings
      self.caption = CAPTION_SETTINGS
      @state = SETTINGS
    end

    def show_controls
      self.caption = CAPTION_CONTROLS
      @state = CONTROLS
    end

    def return_menu
      SettingsFile.save
      self.caption = CAPTION_MAIN_MENU
      @state = MENU
    end

    def toggle_music
      value = !SettingsFile.get(:music)
      SettingsFile.set(:music, value)
      SettingsFile.save
      if value
        @music.play(true)
      else
        @music.stop
      end
    end

    def toggle_fullscreen
      value = !SettingsFile.get(:fullscreen)
      SettingsFile.set(:fullscreen, value)
      SettingsFile.save
      self.fullscreen = value
    end

    def restart
      SettingsFile.save
      Game.reload
      close
    end

    private

    # menu

    def load_menu_textures
      @menu_background = Textures.get(:background_menu)
    end

    def load_defaults
      self.fullscreen = SettingsFile.get(:fullscreen)
      self.caption = CAPTION_MAIN_MENU
      load_menu_textures
      @menu_buttons = create_buttons(menu_buttons_opts)
      create_buttons_commands(@menu_buttons)
    end

    def draw_menu_buttons
      @menu_buttons.map(&:draw)
    end

    def draw_menu
      @menu_background.draw(0, 0, ZOrder::BACKGROUND)
      draw_menu_buttons
    end

    def update_menu
      update_buttons(@menu_buttons)
    end

    def menu_buttons_opts
      {
        names: %w[NEW SETTINGS CONTROLS EXIT],
        commands: %i[start_game show_settings show_controls exit_game]
      }
    end

    # settings

    def load_settings_textures
      @settings_background = Textures.get(:sett_background)
    end

    def load_settings
      load_settings_textures
      @settings_buttons = create_buttons(settings_buttons_opts)
      create_buttons_commands(@settings_buttons)
    end

    def draw_settings_buttons
      @settings_buttons.map(&:draw)
    end

    def draw_settings
      @settings_background.draw(0, 0, ZOrder::BACKGROUND)
      draw_settings_buttons
    end

    def update_settings
      update_buttons(@settings_buttons)
    end

    def settings_buttons_opts
      {
        names: ['BACK', 'TOGGLE MUSIC', 'TOGGLE FULLSCREEN', 'RESTART GAME'],
        commands: %i[return_menu toggle_music toggle_fullscreen restart]
      }
    end

    # controls

    def load_controls_textures
      @controls_background = Textures.get(:controls)
    end

    def load_controls
      load_controls_textures
      @controls_buttons = create_buttons(controls_buttons_opts)
      create_buttons_commands(@controls_buttons)
    end

    def draw_controls_buttons
      @controls_buttons.map(&:draw)
    end

    def draw_controls
      @controls_background.draw(0, 0, ZOrder::BACKGROUND)
      draw_controls_buttons
    end

    def update_controls
      update_buttons(@controls_buttons)
    end

    def controls_buttons_opts
      {
        names: ['BACK'],
        commands: %i[return_menu]
      }
    end

    # music

    def load_music
      @music = Sounds.get(:menu_music)
      @music.volume = SettingsFile.get(:music_volume)
      if SettingsFile.get(:music)
        @music.play(true)
      else
        @music.stop
      end
    end

    # rubocop:disable MethodLength
    def update_buttons(buttons)
      buttons.each do |button|
        button.mouse_entered do |this|
          this.color = 0xff_e7_6f_0d
        end
        button.mouse_exited do |this|
          this.color = 0xff_ff_ff_ff
        end
        button.mouse_clicked do |this|
          this.command
          this.color = 0xff_ff_ff_ff
        end
      end
    end
    # rubocop:enable MethodLength

    def buttons_opts
      {
        width: 150,
        height: 50,
        text: { value: '', height: 25 },
        command: { name: nil }
      }
    end

    def create_buttons(opts)
      buttons = []
      y_offset = height * 0.25
      opts[:names].each_with_index do |name, i|
        options = buttons_opts
        options[:text][:value] = name
        options[:command][:name] = opts[:commands][i]
        buttons << UIElements::Button.new(self, width * 0.05, y_offset, options)
        y_offset += height * 0.1
      end
      buttons
    end

    def create_buttons_commands(buttons)
      buttons.each do |button|
        button.create_command do
          window.send @command_name unless @command_name.nil?
        end
      end
    end
  end
  # rubocop:enable ClassLength
end
