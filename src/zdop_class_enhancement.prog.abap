REPORT zdop_class_enhancement.

DATA gv_string1 TYPE string.
DATA gv_string2 TYPE string.
DATA gv_string3 TYPE string.
DATA gv_sonuc TYPE string.

gv_string1 ='Ne Mutlu'.
gv_string2 ='Türküm'.
gv_string3 ='Diyene'.



CALL METHOD zdop_string_functions=>string_concatenate
  EXPORTING
    iv_string1 = gv_string1
    iv_string2 = gv_string2
    iv_string3 = gv_string3
  IMPORTING
    ev_sonuc   = gv_sonuc.

WRITE:/ gv_sonuc.
