*&---------------------------------------------------------------------*
*&  Include           ZDOP_SCREEN_TOP
*&---------------------------------------------------------------------*
DATA : gv_ad    TYPE char30,
       gv_soyad TYPE char30.

DATA: gv_rad1 TYPE char1,
      gv_rad2 TYPE xfeld.

DATA : gv_cbox TYPE xfeld.

DATA : gv_yas TYPE i.

DATA : gv_id     TYPE vrm_id,
       gt_values TYPE vrm_values,
       gs_value  TYPE vrm_value,
       gv_index  TYPE i VALUE 18.

DATA : gv_date TYPE datum.

DATA : ok_code TYPE sy-ucomm.

DATA : gs_log TYPE zdop_personal.

CONTROLS TS_ID TYPE TABSTRIP.
