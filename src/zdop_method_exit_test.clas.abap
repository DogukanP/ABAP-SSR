class ZDOP_METHOD_EXIT_TEST definition
  public
  final
  create public .

public section.

  methods TOPLAMA_YAP
    importing
      !IV_SAYI1 type I
      !IV_SAYI2 type I .
protected section.
private section.
ENDCLASS.



CLASS ZDOP_METHOD_EXIT_TEST IMPLEMENTATION.


  METHOD toplama_yap.
    DATA : lv_toplam TYPE i.

    lv_toplam = iv_sayi1 + iv_sayi2.
    WRITE:/ 'TOPLAM : ',lv_toplam.
  ENDMETHOD.
ENDCLASS.
