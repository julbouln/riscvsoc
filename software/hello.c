#include "riscvsoc.h"

int main(int argc, char** argv) { 
	int a=6;
	int b=7;
	int c=42;
	char hello[5]="Hello";	
		

//	spi_init();
	GPIO_CTRL = 0b00000011;
//			GPIO_PORT=0b00000001;

//	gpio_mode(1,OUTPUT);
//	gpio_mode(0,OUTPUT);

//		gpio_write(0,HIGH);
//		gpio_write(1,LOW);

	delay(5000);
		
	while(1)
	{	
		/*
		char r;	
		spi_write(64);
		r=spi_read();
		mprintf("read : %c",r);
		*/
		mprintf("%d\n",csr_read(time));
/*		char c=serial_in_char();
		while(c>-1) {
			serial_out_char(c);
			c=serial_in_char();
		}
*/
//		mprintf("b%de",43);
		
//		if(SERIAL_READSIZE)
//			mprintf("receive %c\n",SERIAL_DATA);
		
		mprintf("test int %d\n",43);
		mprintf("test var int %d\n",a);
		mprintf("test hex %x\n",11);
		mprintf("test var hex %x\n",c);
		mprintf("test var string %s\n",hello); 

		mprintf("test char %c\n",64); 
		mprintf("Hello world!\n"); 

		mprintf("add : %d+%d=%d\n",a,b,a+b); 
		mprintf("sub : %d-%d=%d\n",b,a,b-a); 
		mprintf("mul : %d*%d=%d\n",a,b,a*b); 
		mprintf("div : %d/%d=%d\n",c,a,c/a); 
		

		GPIO_PORT=0b00000001;
//		gpio_write(0,HIGH);
//		gpio_write(1,LOW);
		delay(1000);
		GPIO_PORT=0b00000010;
//		gpio_write(0,LOW);
//		gpio_write(1,HIGH);
		delay(1000);
		
	}
	
  return 0; 
}
