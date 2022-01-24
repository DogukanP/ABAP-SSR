class ZDOP_STRING_FUNCTIONS definition
  public
  final
  create public .

public section.

  class-methods STRING_CONCATENATE
    importing
      !IV_STRING1 type STRING
      !IV_STRING2 type STRING
    exporting
      !EV_SONUC type STRING .
protected section.
private section.
ENDCLASS.



CLASS ZDOP_STRING_FUNCTIONS IMPLEMENTATION.


  method STRING_CONCATENATE.
    CLEAR EV_SONUC.
    CONCATENATE IV_STRING1 IV_STRING2 INTO EV_SONUC SEPARATED BY SPACE.
  endmethod.
ENDCLASS.
