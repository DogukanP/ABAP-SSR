"Name: \FU:LAST_WEEK\SE:END\EI
ENHANCEMENT 0 ZDOP_STD_FM_CODE_ENHANCEMENT.
*
  data tatil_gunu_tablosu_zdop type table of iscal_day.

  CALL FUNCTION 'HOLIDAY_GET'
  EXPORTING
    HOLIDAY_CALENDAR = 'GE'
    DATE_FROM = Monday
    DATE_TO = Sunday
  TABLES
    holidays = tatil_gunu_tablosu_zdop
  EXCEPTIONS
    FACTORY_CALENDAR_NOT_FOUND = 1
    HOLIDAY_CALENDAR_NOT_FOUND = 2
    DATE_HAS_INVALID_FORMAT = 3
    DATE_INCONSISTENCY = 4
    OTHERS = 5.

  IF sy-subrc = 0.
    TATIL_GUNU_SAYISI_5 = lines( tatil_gunu_tablosu_zdop ).
  ENDIF.
ENDENHANCEMENT.
