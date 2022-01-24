*----------------------------------------------------------------------*
***INCLUDE LZDOP_MATERIAL_DATAO02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  MALZEME_TANIMI_OKU  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE malzeme_tanimi_oku OUTPUT.
  DATA : GV_MATNR TYPE MATNR.
  TABLES ZDOP_MAT_DES.
  IF SY-TCODE EQ 'MM02' OR SY-TCODE EQ 'MM03'.
    GET PARAMETER ID 'MAT' FIELD GV_MATNR.
    IF GV_MATNR IS NOT INITIAL.
      SELECT SINGLE TANIM
        FROM ZDOP_MAT_DES
        INTO ZDOP_MAT_DES-TANIM
        WHERE MATNR EQ GV_MATNR AND DIL EQ SY-LANGU.
      IF SY-SUBRC EQ 0.
        RETURN.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMODULE.
