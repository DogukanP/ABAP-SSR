REPORT zdop_salv_01.

DATA: gt_sbook TYPE TABLE OF sbook,
      go_salv  TYPE REF TO cl_salv_table.

START-OF-SELECTION.

  SELECT * UP TO 20 ROWS FROM sbook INTO TABLE gt_sbook.

  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = go_salv
    CHANGING
      t_table        = gt_sbook
  ).

  DATA : lo_display TYPE REF TO cl_salv_display_settings.
  lo_display = go_salv->get_display_settings( ).
  lo_display->set_list_header( value = 'SALV DENEMESİ 1' ).
  lo_display->set_striped_pattern( value = 'X' ).


  DATA: lo_cols TYPE REF TO cl_salv_columns.
  lo_cols = go_salv->get_columns( ).
  lo_cols->set_optimize( value = 'X' ).

  data : LO_COL TYPE REF TO cl_salv_column.

  lo_col = lo_cols->get_column( columnname = 'MANDT' ).
  lo_col->set_visible( value = if_salv_c_bool_sap=>false ).


  go_salv->display( ).
