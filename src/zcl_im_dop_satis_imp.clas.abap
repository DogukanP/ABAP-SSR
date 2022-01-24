class ZCL_IM_DOP_SATIS_IMP definition
  public
  final
  create public .

public section.

  interfaces ZIF_EX_DOP_SATIS_BADI .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_DOP_SATIS_IMP IMPLEMENTATION.


  METHOD zif_ex_dop_satis_badi~satis_dokuman_filtrele.
    DATA : ls_vbap TYPE vbap.

    LOOP AT ct_vbap INTO ls_vbap.
      IF ls_vbap-matnr EQ 'M-02'.
        DELETE ct_vbap.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
