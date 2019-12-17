;;
; Copyright Jacques Deschênes 2019 
; This file is part of tbi 
;
;     tbi is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     tbi is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with tbi.  If not, see <http://www.gnu.org/licenses/>.
;;
;-------------------------------------------------
;  TinyBASIC virtual machine
;  a 2 stack virtual machine 
;   Control stack is the normal SP stack 
;   expression stack X as pointer 
;   VM program counter use Y. 
;--------------------------------------------------

	.module TBI_VM 
    .optsdcc -mstm8
;	.nlist
	.include "../inc/nucleo_8s208.inc"
	.include "../inc/stm8s208.inc"
	.include "../inc/ascii.inc"
	.include "../inc/gen_macros.inc"
;	.include "tbi.inc"

;----------------------------------------------
;    VM OPCODES 
;  CODE     MNEMO       DESCRIPTION
; 00-07     SX n        stack exchange 
;                       arg.stack 
;                       n {0..7} 
;                       0 top of stack 
;   08      NO          no operation 
;   09      LB b        push literal byte on 
;                       arg.stack        
;   0A      LN w        push literal integer
;                       on arg.stack. 
;   0B      DS          DUP arg.stack top integer 
;   0C      SP          drop arg.stack top integer 
;   10      SB          if BasicPtr in tib then SavePtr <- BasicPtr else exchange both
;   11      RB          if SavePtr in tib then BasicPtr <- SavePtr else exchange 
;   12      FV          fetch variable { adr -- value }
;   13      SV          store variable in {value adr -- }
;   14      GS          GOSUB  push BASIC line number on ctrl.stack 
;   15      RS          RETURN pop BASIC line number from ctrl.stack 
;   16      GO          GOTO  replace BASIC line number { lineno -- }
;   17      NE          two's complement { n -- -n }
;   18      AD          add 2 {n1 n2 -- n1+n2}
;   19      SU          sub  {n1 n2 -- n2-n1}
;   1A      MP          multiply N*T {n1 n2 -- n1*n2}
;   1B      DV          divide T/N  {n1 n2 -- n1/n2}
;   1C      CP          compare {n1 mask n2 -- }  n2-n1 -> mask bits 0:2 
;                       bit 0 less than 
;                       bit 1 equal 
;                       bit 2 greater than 
;                       jump over next IL if 1 bit is set.
;                       all 5 bytes are dropped see page 21 for details
;   1D      NX          Advance BASIC pointer to next line.
;   1F      LS          List BASIC lines {last first --  }        
;   20      PN          Print number {n -- }
;   21      PS          Print string pointer by BASIC pointer 
;   22      BT          Print tabulation to align modulo 8.
;   23      NL          Send CRLF to terminal 
;   24      PC          Print literal string that follow opcode 
;   27      GL          Read line from terminal in tib 
;   2A      IL          Insert BASIC line  
;   2B      MT          Mark BASIC program space empty 
;   2C      XQ          Execute BASIC program 
;   2D      WS          STOP basic execution and restart IL in command mode.
;   2E      US          USR call {arg1 arg2 addr -- }
;   2F      RT          return form IL sub-routine 
;   3000-37FF JS        call IL sub-routine 
;   3800-3FFF J         jump to IL address   
;   40-7F  BR           IL relative branch bit 5 is sign 1 + 0 - 
;   80-9F  BC           string compare branch on equal, opcode followed by string
;                       to compare with BASIC pointed string  
;   A0-BF  BV           branch if not variable (5 bits offset)
;   C0-DF  BN           branch if not a number (5 bits offset )
;   E0-FF  BE           branch if not end of line (5 bits offset ) 
;------------------------------------------------------------------------------

    .area DATA 

    .area CODE 
name: .asciz "TBI_VM" 
; vm entry for cold start  
vm_init::




