/*
* 2019/04/04
*  clock  intialization
* 
*/
#include "../inc/stm8s105.h"

// initialize clock to use HSE 16 Mhz crystal
void clock_init(int wait){
		_setbit(CLK_SWCR,CLK_SWCR_SWEN);
		CLK_SWR=CLK_SWR_HSE;
		if (wait){
			while (CLK_CMSR!=CLK_SWR_HSE);
		}
		
}

