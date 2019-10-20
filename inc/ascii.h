/*
* Copyright Jacques Deschênes 2018, 2019 
* This file is part of BPOS.
*
*     BPOS is free software: you can redistribute it and/or modify
*     it under the terms of the GNU General Public License as published by
*     the Free Software Foundation, either version 3 of the License, or
*     (at your option) any later version.
*
*     BPOS is distributed in the hope that it will be useful,
*     but WITHOUT ANY WARRANTY; without even the implied warranty of
*     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*     GNU General Public License for more details.
*
*     You should have received a copy of the GNU General Public License
*     along with BPOS.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
 * Description: caractères spéciaux ASCII
 * Auteur: PICATOUT
 * Date: 2018-10-06
 * Copyright Jacques Deschênes, 2018
 * Licence: GPLv3
 * revisions:
 * 
 */

#ifndef ASCII_H
#define ASCII_H

typedef enum ASCII_CTRL{
	NUL=0,
	SOH,
	STX,
	ETX,
	EOT,
	ENQ,
	ACK,
	BEL,
	BS,
	TAB,
	LF,
	VT,
	FF,
	CR,
	SO,
	SI,
	DLE,
	DC1,
	DC2,
	DC3,
	DC4,
	NAK,
	SYN,
	ETB,
	CAN,
	EM,
	SUB,
	ESC,
	FS,
	GS,
	RS,
	US,
	SPACE
}ascii_ctrl_e;


#define CTRL_A SOH
#define CTRL_B STX
#define CTRL_C ETX
#define CTRL_D EOT
#define CTRL_E ENQ
#define CTRL_F ACK
#define CTRL_G BEL
#define CTRL_H BS
#define CTRL_I TAB
#define CTRL_J LF
#define CTRL_K VT
#define CTRL_L FF
#define CTRL_M CR
#define CTRL_N SO
#define CTRL_O SI
#define CTRL_P DLE
#define CTRL_Q DC1
#define CTRL_R DC2
#define CTRL_S DC3
#define CTRL_T DC4
#define CTRL_U NAK
#define CTRL_V SYN
#define CTRL_W ETB
#define CTRL_X CAN
#define CTRL_Y EM
#define CTRL_Z SUB

#endif // ASCII_H
