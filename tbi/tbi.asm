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

;  
	.module TBI
    .optsdcc -mstm8
;	.nlist
	.include "../inc/nucleo_8s208.inc"
	.include "../inc/stm8s208.inc"
	.include "../inc/ascii.inc"
	.include "../inc/gen_macros.inc"
;	.include "tbi.inc"


    .area DATA 

    .area SSEG 

    .area HOME 

    .area CODE 

