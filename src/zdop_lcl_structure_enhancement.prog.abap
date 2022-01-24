REPORT zdop_lcl_structure_enhancement.
*MARA tablosundan secilecek alanlar
*icin structure ve internal tablo
*tantmlanması
DATA: BEGIN OF gs_mara,
        matnr TYPE matnr,
        ernam TYPE ernam,
        mtart TYPE mtart,
        matkl TYPE matkl,
      END OF gs_mara.

DATA gt_mara LIKE TABLE OF gs_mara.
DATA go_alv TYPE REF TO cl_salv_table.

START-OF-SELECTION.
*mara tablosundan maksimum 50 kaydi gt_mara internal tablosuna sec
  select * from mara into corresponding fields of table gt_mara up to 50 rows.

*ALV smıfım kullanarak verileri ALV listesi olarak göster
  CALL METHOD cl_salv_table=>factory
    IMPORTING
      r_salv_table = go_alv
    CHANGING
      t_table      = gt_mara.
  go_alv->display( ).
