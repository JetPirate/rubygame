# frozen_string_literal: true

module Resources
  module Captions
    # rubocop:disable MutableConstant
    MAIN_MENU = 'MENU'
    GAME = 'GAME'
    SETTINGS = 'SETTINGS'
    CONTROLS = 'CONTROLS'
    PAUSE = 'PAUSE'
    # rubocop:enable MutableConstant
  end
  module Colors
    # rubocop:disable LeadingCommentSpace
    WHITE = 0xff_ff_ff_ff     #ffffff
    TEXT_MENU = 0xff_6c_a8_f7 #6ca8f7
    TEXT_MAIN = 0xff_e7_6f_0d #e76f0d
    # rubocop:enable LeadingCommentSpace
  end
  module Controls
    # rubocop:disable MethodLength, CyclomaticComplexity
    def self.key_id_to_s(id)
      case id
      when Gosu::KbQ         then 'Q'
      when Gosu::KbW         then 'W'
      when Gosu::KbE         then 'E'
      when Gosu::KbR         then 'R'
      when Gosu::KbT         then 'T'
      when Gosu::KbY         then 'Y'
      when Gosu::KbU         then 'U'
      when Gosu::KbI         then 'I'
      when Gosu::KbO         then 'O'
      when Gosu::KbP         then 'P'
      when Gosu::KbA         then 'A'
      when Gosu::KbS         then 'S'
      when Gosu::KbD         then 'D'
      when Gosu::KbF         then 'F'
      when Gosu::KbG         then 'G'
      when Gosu::KbH         then 'H'
      when Gosu::KbJ         then 'J'
      when Gosu::KbK         then 'K'
      when Gosu::KbL         then 'L'
      when Gosu::KbZ         then 'Z'
      when Gosu::KbX         then 'X'
      when Gosu::KbC         then 'C'
      when Gosu::KbV         then 'V'
      when Gosu::KbB         then 'B'
      when Gosu::KbN         then 'N'
      when Gosu::KbM         then 'M'
      when Gosu::KbLeftShift then 'LShift'
      when Gosu::Kb1         then '1'
      when Gosu::Kb2         then '2'
      when Gosu::Kb3         then '3'
      when Gosu::Kb4         then '4'
      when Gosu::Kb5         then '5'
      when Gosu::Kb6         then '6'
      when Gosu::Kb7         then '7'
      when Gosu::Kb8         then '8'
      when Gosu::Kb9         then '9'
      when Gosu::Kb0         then '0'
      when Gosu::KbEscape    then 'ESC'
      when Gosu::GP_UP,
           Gosu::GP_0_UP,
           Gosu::GP_1_UP,
           Gosu::GP_2_UP,
           Gosu::GP_3_UP then 'Stick/D-pad Up'
      when Gosu::GP_LEFT,
           Gosu::GP_0_LEFT,
           Gosu::GP_1_LEFT,
           Gosu::GP_2_LEFT,
           Gosu::GP_3_LEFT then 'Stick/D-pad Left'
      when Gosu::GP_DOWN,
           Gosu::GP_0_DOWN,
           Gosu::GP_1_DOWN,
           Gosu::GP_2_DOWN,
           Gosu::GP_3_DOWN then 'Stick/D-pad Down'
      when Gosu::GP_RIGHT,
           Gosu::GP_0_RIGHT,
           Gosu::GP_1_RIGHT,
           Gosu::GP_2_RIGHT,
           Gosu::GP_3_RIGHT then 'Stick/D-pad Right'
      when Gosu::GP_BUTTON_0,
           Gosu::GP_0_BUTTON_0,
           Gosu::GP_1_BUTTON_0,
           Gosu::GP_2_BUTTON_0,
           Gosu::GP_3_BUTTON_0 then '3/X/A'
      when Gosu::GP_BUTTON_1,
           Gosu::GP_0_BUTTON_1,
           Gosu::GP_1_BUTTON_1,
           Gosu::GP_2_BUTTON_1,
           Gosu::GP_3_BUTTON_1 then '2/O/B'
      when Gosu::GP_BUTTON_2,
           Gosu::GP_0_BUTTON_2,
           Gosu::GP_1_BUTTON_2,
           Gosu::GP_2_BUTTON_2,
           Gosu::GP_3_BUTTON_2 then '4/□/X'
      when Gosu::GP_BUTTON_3,
           Gosu::GP_0_BUTTON_3,
           Gosu::GP_1_BUTTON_3,
           Gosu::GP_2_BUTTON_3,
           Gosu::GP_3_BUTTON_3 then '1/∆/Y'
      when Gosu::GP_BUTTON_4,
           Gosu::GP_0_BUTTON_4,
           Gosu::GP_1_BUTTON_4,
           Gosu::GP_2_BUTTON_4,
           Gosu::GP_3_BUTTON_4 then 'Select/Share/Back'
      when Gosu::GP_BUTTON_5,
           Gosu::GP_0_BUTTON_5,
           Gosu::GP_1_BUTTON_5,
           Gosu::GP_2_BUTTON_5,
           Gosu::GP_3_BUTTON_5 then 'Analog/Mode'
      when Gosu::GP_BUTTON_6,
           Gosu::GP_0_BUTTON_6,
           Gosu::GP_1_BUTTON_6,
           Gosu::GP_2_BUTTON_6,
           Gosu::GP_3_BUTTON_6 then 'Start/Options'
      when Gosu::GP_BUTTON_7,
           Gosu::GP_0_BUTTON_7,
           Gosu::GP_1_BUTTON_7,
           Gosu::GP_2_BUTTON_7,
           Gosu::GP_3_BUTTON_7 then 'LStick'
      when Gosu::GP_BUTTON_8,
           Gosu::GP_0_BUTTON_8,
           Gosu::GP_1_BUTTON_8,
           Gosu::GP_2_BUTTON_8,
           Gosu::GP_3_BUTTON_8 then 'RStick'
      when Gosu::GP_BUTTON_9,
           Gosu::GP_0_BUTTON_9,
           Gosu::GP_1_BUTTON_9,
           Gosu::GP_2_BUTTON_9,
           Gosu::GP_3_BUTTON_9 then 'L1/Left Bumper'
      when Gosu::GP_BUTTON_10,
           Gosu::GP_0_BUTTON_10,
           Gosu::GP_1_BUTTON_10,
           Gosu::GP_2_BUTTON_10,
           Gosu::GP_3_BUTTON_10 then 'R1/Right Bumper'
      when Gosu::GP_BUTTON_11,
           Gosu::GP_0_BUTTON_11,
           Gosu::GP_1_BUTTON_11,
           Gosu::GP_2_BUTTON_11,
           Gosu::GP_3_BUTTON_11 then 'L2/Left Trigger'
      when Gosu::GP_BUTTON_12,
           Gosu::GP_0_BUTTON_12,
           Gosu::GP_1_BUTTON_12,
           Gosu::GP_2_BUTTON_12,
           Gosu::GP_3_BUTTON_12 then 'R2/Right Trigger'
      else
        'Undefined'
      end
    end
    # rubocop:enable MethodLength, CyclomaticComplexity
  end
end
