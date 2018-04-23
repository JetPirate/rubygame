# Module with z-orders for textures
module ZOrder
  BACKGROUND, DEAD, HUMAN, PLAYER, UI = *0..4
  # Submodule for UI
  module UIOrder
    BUTTON = ZOrder::UI
    BUTTON_TEXT = BUTTON + 1
    LABEL = ZOrder::UI
    LABEL_TEXT = LABEL + 1
    TEXT = ZOrder::UI + 1
  end
end
