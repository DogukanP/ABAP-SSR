REPORT zdop_enhancement_section_demo.

DATA gt_ekko TYPE TABLE OF ekko.

SELECT * FROM ekko INTO TABLE gt_ekko UP TO 1000 ROWS.

ENHANCEMENT-SECTION ZDOP_ENH_ALV SPOTS ZDOP_SPOT3 .

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_structure_name = 'EKKO'
  TABLES
    t_outtab         = gt_ekko.

END-ENHANCEMENT-SECTION.
