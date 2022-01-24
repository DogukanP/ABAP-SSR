class ZCL_EX_DOP_MUST_BADI definition
  public
  final
  create public .

public section.

  interfaces ZIF_EX_DOP_MUST_BADI .

  constants VERSION type VERSION value 000001 ##NO_TEXT.
protected section.
private section.

  constants FLT_PATTERN type FILTNAME value '' ##NO_TEXT.
  data INSTANCE_BADI_TABLE type SXRT_EXIT_TAB .
  data INSTANCE_FLT_CACHE type SXRT_FLT_CACHE_TAB .
ENDCLASS.



CLASS ZCL_EX_DOP_MUST_BADI IMPLEMENTATION.
ENDCLASS.
