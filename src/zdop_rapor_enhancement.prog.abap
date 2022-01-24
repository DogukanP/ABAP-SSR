REPORT zdop_rapor_enhancement.

*MARA tablosundan secilecek alanlar
*icin structure ve intema/ tablo
*tanımlanması
DATA: BEGIN OF gs_mara,
        matnr TYPE matnr,
        ernam TYPE ernam,
        mtart TYPE mtart,
        matkl TYPE matkl,
      END OF gs_mara.

DATA gt_mara LIKE TABLE OF gs_mara.

START-OF-SELECTION.

*MARA tablosundan maksimum 5 kaydı GT_ MARA
*intemal tablosuna sec
  SELECT * FROM mara INTO CORRESPONDING FIELDS OF TABLE gt_mara UP TO 5 ROWS.
  WRITE :/ 'Malzeme Listesi Raporu'.
  SKIP 2.

*Secilen kayıtların ekrana yazdırılması

  LOOP AT gt_mara INTO gs_mara.
    WRITE :/ gs_mara-matnr,
             gs_mara-ernam,
             gs_mara-mtart,
             gs_mara-matkl.
  ENDLOOP.
