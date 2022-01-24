*&---------------------------------------------------------------------*
*&  Include           ZDOP_TABSTRIP_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN 'TAB1'.
      tb_id-activetab = 'TAB1'.
    WHEN 'TAB2'.
      tb_id-activetab = 'TAB2'.
  ENDCASE.
ENDMODULE.
