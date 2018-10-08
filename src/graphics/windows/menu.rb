# frozen_string_literal: true

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
      caption_controls_key(id) if @_read_controls_key
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
      self.caption = Captions::SETTINGS
      @state = SETTINGS
    end

    def show_controls
      self.caption = Captions::CONTROLS
      @state = CONTROLS
    end

    def return_menu
      SettingsFile.save
      self.caption = Captions::MAIN_MENU
      @state = MENU
    end

    def save_controls
      SettingsFile.set(:controls, controls)
      SettingsFile.save
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

    def toggle_controls_mode
      mode = SettingsFile.get(:controls_mode)
      mode = case mode
             when :keyboard then :gamepad
             when :gamepad  then :keyboard
             else :keyboard
             end
      SettingsFile.set(:controls_mode, mode)
      SettingsFile.save
      load_controls
    end

    def restart
      SettingsFile.save
      Game.reload
      close
    end

    def read_controls_key(field)
      @_draw_press_key = true
      @_read_controls_key = true
      @chosen_controls_field = field
    end

    private

    # menu

    def load_menu_textures
      @menu_background = Textures.get(:background_menu)
    end

    def load_defaults
      self.fullscreen = SettingsFile.get(:fullscreen)
      self.caption = Captions::MAIN_MENU
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
        names: ['BACK', 'MUSIC', 'FULLSCREEN', 'RESTART GAME'],
        commands: %i[return_menu toggle_music toggle_fullscreen restart]
      }
    end

    # controls

    def load_controls_textures
      @controls_background = Textures.get(:controls)
      @controls_press_key = Textures.get(:press_key)
    end

    def load_controls
      load_controls_textures
      @controls_buttons = create_buttons(controls_buttons_opts)
      @controls_input_labels = create_input_labels(controls_input_opts)
      @controls_input_fields = create_input_fields(controls_input_opts)
      create_buttons_commands(@controls_buttons)
    end

    def draw_controls_buttons
      @controls_buttons.map(&:draw)
    end

    def draw_controls_input_labels
      @controls_input_labels.map(&:draw)
    end

    def draw_controls_input_fields
      @controls_input_fields.map(&:draw)
    end

    def draw_press_key
      x = width / 2 - @controls_press_key.width / 2
      y = height / 2 - @controls_press_key.height / 2
      @controls_press_key.draw(x, y, ZOrder::UIOrder::ACTION_REQUIRED)
    end

    def draw_controls
      @controls_background.draw(0, 0, ZOrder::BACKGROUND)
      draw_controls_buttons
      draw_controls_input_labels
      draw_controls_input_fields
      draw_press_key if @_draw_press_key
    end

    def update_controls
      update_buttons(@controls_buttons)
      update_buttons(@controls_input_fields)
    end

    def caption_controls_key(id)
      @_read_controls_key = false
      @_draw_press_key = false
      return if @chosen_controls_field.nil?
      @chosen_controls_field.extensions[:key_id] = id
      @chosen_controls_field.refresh do |field|
        field.value = Controls.key_id_to_s(id)
      end
    end

    def controls_buttons_opts
      {
        names: %w[BACK SAVE KEYBOARD/GAMEPAD],
        commands: %i[return_menu save_controls toggle_controls_mode]
      }
    end

    def controls_input_opts
      {
        names: ['UP', 'DOWN', 'LEFT', 'RIGHT', 'SPEED UP', 'PAUSE',
                'MUSIC UP', 'MUSIC DOWN', 'BACK'],
        commands: %i[read_controls_key]
      }
    end

    def controls
      mode = SettingsFile.get(:controls_mode)
      current_controls = SettingsFile.get(:controls)
      current_controls[mode] = {}.tap do |keys|
        @controls_input_fields.each_with_index do |field, i|
          action = controls_input_opts[:names][i].to_sym
          keys[action] = field.extensions[:key_id]
        end
      end
      current_controls
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
          this.color = Colors::TEXT_MENU
        end
        button.mouse_exited do |this|
          this.color = Colors::WHITE
        end
        button.mouse_clicked do |this|
          this.command
          this.color = Colors::WHITE
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

    def input_labels_opts
      {
        width: 150,
        height: 50,
        text: { value: '', height: 25, align: :right }
      }
    end

    def input_fields_opts
      {
        width: 150,
        height: 50,
        image: Textures.get(:default_input_field),
        text: { value: '', height: 25, align: :left },
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
          if @command_name == :read_controls_key
            window.send(@command_name, self)
          else
            window.send(@command_name)
          end
        end
      end
    end

    def create_input_labels(opts)
      labels = []
      y_offset = height * 0.10
      opts[:names].each do |name|
        options = input_labels_opts
        options[:text][:value] = name
        labels << UIElements::Label.new(self, width * 0.45, y_offset, options)
        y_offset += height * 0.1
      end
      labels
    end

    def create_input_fields(opts)
      fields = []
      y_offset = height * 0.10
      mode = SettingsFile.get(:controls_mode)
      opts[:names].each do |name|
        options = input_fields_opts
        options[:command][:name] = opts[:commands][0]
        options[:extensions] = {}
        options[:extensions][:key_id] = SettingsFile.get(:controls)[mode][name.to_sym]
        options[:text][:value] = Controls.key_id_to_s(
          options[:extensions][:key_id]
        )
        fields << UIElements::Button.new(self, width * 0.75, y_offset,
                                         options)
        y_offset += height * 0.1
      end
      fields
    end
  end
  # rubocop:enable ClassLength
end
