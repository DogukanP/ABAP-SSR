CLASS LCL_ZDOP_METHOD_EXIT DEFINITION DEFERRED.
CLASS ZDOP_METHOD_EXIT_TEST DEFINITION LOCAL FRIENDS LCL_ZDOP_METHOD_EXIT.
CLASS LCL_ZDOP_METHOD_EXIT DEFINITION.
PUBLIC SECTION.
CLASS-DATA OBJ TYPE REF TO LCL_ZDOP_METHOD_EXIT. "#EC NEEDED
DATA CORE_OBJECT TYPE REF TO ZDOP_METHOD_EXIT_TEST . "#EC NEEDED
 INTERFACES: IPR_ZDOP_METHOD_EXIT, IPO_ZDOP_METHOD_EXIT.
  METHODS:
   CONSTRUCTOR IMPORTING CORE_OBJECT
     TYPE REF TO ZDOP_METHOD_EXIT_TEST OPTIONAL.
ENDCLASS.
CLASS LCL_ZDOP_METHOD_EXIT IMPLEMENTATION.
METHOD CONSTRUCTOR.
  ME->CORE_OBJECT = CORE_OBJECT.
ENDMETHOD.

METHOD IPR_ZDOP_METHOD_EXIT~TOPLAMA_YAP.
*"------------------------------------------------------------------------*
*" Declaration of PRE-method, do not insert any comments here please!
*"
*"methods TOPLAMA_YAP
*"  importing
*"    !IV_SAYI1 type I
*"    !IV_SAYI2 type I .
*"------------------------------------------------------------------------*
  SKIP 1.
  WRITE :/ 'DOĞUKAN PADEL METHOD EXIT DENEMESİ'.
  WRITE :/ 'TOPLAMA METODUNDAN ÖNCE ÇALIŞACAK KODLAR'.
  WRITE :/ 'PRE-EXIT...'.
  SKIP 1.
  ULINE.


ENDMETHOD.
METHOD IPO_ZDOP_METHOD_EXIT~TOPLAMA_YAP.
*"------------------------------------------------------------------------*
*" Declaration of POST-method, do not insert any comments here please!
*"
*"methods TOPLAMA_YAP
*"  importing
*"    !IV_SAYI1 type I
*"    !IV_SAYI2 type I .
*"------------------------------------------------------------------------*
  ULINE.
  SKIP 1.
  WRITE :/ 'DOĞUKAN PADEL METHOD EXIT DENEMESİ'.
  WRITE :/ 'TOPLAMA METODUNDAN SONRA ÇALIŞACAK KODLAR'.
  WRITE :/ 'POST-EXIT...'.
  SKIP 1.
  ULINE.
ENDMETHOD.
ENDCLASS.
