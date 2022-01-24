REPORT zdop_form_exit.

DATA gt_ekko TYPE TABLE OF ekko.

PERFORM ekko_kayitlari_sec.
PERFORM ekko_kayitlari_goster.

****Subroutine tanimlari****
*EKKO Kayıtlanm Secen Subroutine

FORM ekko_kayitlari_sec.
*EKKO tablosundan maksimum 1000
*kaydi GT_EKKO intemal tablosuna sec

  SELECT * FROM ekko INTO TABLE gt_ekko UP TO 1000 ROWS.

ENDFORM. "ekko_ kayitlari_sec

*EKKO Kayıtlarmı Gosteren Subroutine.
FORM ekko_kayitlari_goster.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_structure_name = 'EKKO'
    TABLES
      t_outtab         = gt_ekko.
ENDFORM. "ekko _kayitlari_goster
