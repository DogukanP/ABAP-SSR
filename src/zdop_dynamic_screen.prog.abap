
REPORT ZDOP_DYNAMIC_SCREEN.

DATA : GV_NAME TYPE CHAR20,
       GV_LASTNAME TYPE CHAR20,
       GV_AGE TYPE I.

START-OF-SELECTION.

call screen 0100.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
*  SET TITLEBAR 'xxx'.

*  LOOP AT SCREEN.
*    IF SCREEN-NAME EQ 'GV_NAME'.
*      SCREEN-ACTIVE = 0.
*      MODIFY SCREEN.
*    ENDIF.
*    IF SCREEN-NAME EQ 'GV_LASTNAME'.
*      SCREEN-INVISIBLE = 1.
*      MODIFY SCREEN.
*    ENDIF.
*    IF SCREEN-NAME EQ 'GV_AGE'.
*      SCREEN-INPUT = 0.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.

  LOOP AT SCREEN.
    IF SCREEN-GROUP1 EQ 'X'.
      SCREEN-INPUT = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
