*&---------------------------------------------------------------------*
*&  Include           ZDOP_SCREEN_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CLEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clear .
  CLEAR : gv_ad,
              gv_soyad,
              gv_yas,
              gv_cbox,
              gv_date,
              gv_rad2.
  gv_rad1 = abap_true.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SAVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save .
  gs_log-ad = gv_ad.
  gs_log-soyad = gv_soyad.
  gs_log-yas = gv_yas.
  gs_log-dogum_tarihi = gv_date.
  gs_log-cb = gv_cbox.
  IF gv_rad1 EQ 'X'.
    gs_log-cinsiyet = 'K'.
  ELSE.
    gs_log-cinsiyet = 'E'.
  ENDIF.
  INSERT zdop_personal FROM gs_log.
  COMMIT WORK AND WAIT.
  IF sy-subrc EQ 0.
    MESSAGE 'KAYIT GERÇEKLEŞTİ' TYPE 'S'.
  ELSE.
    MESSAGE 'KAYIT BAŞARISIZ' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ADD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM add_data .
  gv_id = 'GV_YAS'.

  DO 80 TIMES.
    gs_value-key = gv_index.
    gs_value-text = gv_index.
    APPEND gs_value TO gt_values.
    gv_index = gv_index + 1.
  ENDDO.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = gv_id
      values = gt_values.
ENDFORM.
