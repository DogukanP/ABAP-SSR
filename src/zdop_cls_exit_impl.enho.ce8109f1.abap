"Name: \TY:CL_WDR_FLIGHTS\ME:GET_SPFLI\SE:END\EI
ENHANCEMENT 0 ZDOP_CLS_EXIT_IMPL.
*
  data lv_kayit_sayisi type i.

  FIELD-SYMBOLS <fs_data> TYPE STANDARD TABLE.
  lv_kayit_sayisi = kayit_sayisi7 + 1.
  ASSIGN data to <fs_data>.
  delete <fs_data> FROM lv_kayit_sayisi.
ENDENHANCEMENT.
