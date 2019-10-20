/*
 * 2019/04/04
 * GPIO configuration
 */

#include "../inc/stm8s105.h"

void set_pin_mode(int port, int pin, int mode){
	volatile gpio_t* gpio=(volatile gpio_t*)(GPIO+port*sizeof(gpio_t));
	if (mode&4){
		_setbit(gpio->ddr,pin);
	}else{
		_clrbit(gpio->ddr,pin);
	}
	switch(mode){
		case INPUT_FLOAT_DI:
		case OUTPUT_OD_SLOW:
			_clrbit(gpio->cr1,pin);
			_clrbit(gpio->cr2,pin);
			break;
		case INPUT_FLOAT_EI:
		case OUTPUT_OD_FAST:
			_clrbit(gpio->cr1,pin);
			_setbit(gpio->cr2,pin);
			break;
		case INPUT_PU_DI:
		case OUTPUT_PP_SLOW:
			_setbit(gpio->cr1,pin);
			_clrbit(gpio->cr2,pin);
			break;
		case INPUT_PU_EI:
		case OUTPUT_PP_FAST:
			_setbit(gpio->cr1,pin);
			_setbit(gpio->cr2,pin);
			break;
	}
}

