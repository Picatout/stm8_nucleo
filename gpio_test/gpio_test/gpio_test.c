#include <stdint.h>
#define PC_ODR *(volatile uint8_t*) 0x500a
#define PC_IDR *(volatile uint8_t*) 0x500b
#define PC_DDR *(volatile uint8_t*) 0x500c
#define PC_CR1 *(volatile uint8_t*) 0x500d
#define PC_CR2 *(volatile uint8_t*) 0x500e
#define WWDG_CR *(volatile uint8_t*) 0x50d1

#define LED2 (1<<5)

#define DELAY 0XFFFF

int main(){
   uint32_t delay;
   PC_DDR|=LED2;
   PC_CR1|=LED2;
//   WWDG_CR=0x80; // used to reset mcu
   while (1){
        PC_ODR^=LED2;
        for (delay=0;delay<DELAY;delay++);
   }

}
