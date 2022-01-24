REPORT zdop_subscreen.

INCLUDE zdop_subscreen_top.
INCLUDE zdop_subscreen_f01.
INCLUDE zdop_subscreen_i01.
INCLUDE zdop_subscreen_o01.

START-OF-SELECTION.
  perform get_data.
  CALL SCREEN 0100.
