class ZCL_EX_DOP_SATIS_BADI definition
  public
  final
  create public .

public section.

  interfaces ZIF_EX_DOP_SATIS_BADI .

  constants VERSION type VERSION value 000001 ##NO_TEXT.
protected section.
private section.

  data INSTANCE_BADI_TABLE type SXRT_EXIT_TAB .
  data INSTANCE_FLT_CACHE type SXRT_FLT_CACHE_TAB .
ENDCLASS.



CLASS ZCL_EX_DOP_SATIS_BADI IMPLEMENTATION.
ENDCLASS.
