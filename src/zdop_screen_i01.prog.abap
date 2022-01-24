*&---------------------------------------------------------------------*
*&  Include           ZDOP_SCREEN_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  ok_code = sy-ucomm.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CLEAR'.
      perform clear.
    WHEN 'SAVE'.
      perform save.
    WHEN 'TAB1'.
      TS_ID-activetab = 'TAB1'.
    WHEN 'TAB2'.
      TS_ID-activetab = 'TAB2'.
  ENDCASE.
ENDMODULE.
