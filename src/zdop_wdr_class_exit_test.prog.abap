REPORT ZDOP_WDR_CLASS_EXIT_TEST.

DATA gt_spfli TYPE TABLE OF spfli.
DATA go_alv TYPE REF TO cl_salv_table.

START-OF-SELECTION.

*SPFLI Kayitlarini Veritabanindan Oku,
*3. kayittan itibaren olan kayitlari
*sil ve sonucu GT_ SPFLI internal tablosuna ata

CALL METHOD cl_wdr_flights=>get_spfli
  EXPORTING
    countryfr = 'DE'
    cityfrom = 'FRANKFURT'
*    kayit_sayisi7 = 2
  CHANGING
    data = gt_spfli.

*Sonucu ALV grid olarak goster

CALL METHOD cl_salv_table=>factory
  IMPORTING
    r_salv_table = go_alv
  CHANGING
    t_table = gt_spfli.

go_alv->display( ).
