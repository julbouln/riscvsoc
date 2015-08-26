#include <stdio.h>
#include "riscvsoc.h"

int main(int argc, char** argv) { 
	int a=6;
	int b=7;
	int c=42;
	char hello[5]="Hello";	
	char *hello_ptr;

	hello_ptr=(char*)malloc(5);
	hello_ptr[0]='H';
	hello_ptr[1]='e';
	hello_ptr[2]='l';
	hello_ptr[3]='l';
	hello_ptr[4]='o';

		

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
		  printf("time %d %d\n",csr_timeh(),csr_time());

//		printf("%d\n",time());
/*		char c=serial_in_char();
		while(c>-1) {
			serial_out_char(c);
			c=serial_in_char();
		}
*/
//		mprintf("b%de",43);
		
//		if(SERIAL_READSIZE)
//			mprintf("receive %c\n",SERIAL_DATA);
		
		printf("test int %d\n",43);
		printf("test var int %d\n",a);
		printf("test hex %x\n",11);
		printf("test var hex %x\n",c);
		printf("test var string %s\n",hello); 
		printf("test ptr string %s\n",hello_ptr);

		printf("test char %c\n",64); 
		printf("Hello world!\n"); 

		printf("add : %d+%d=%d\n",a,b,a+b); 
		printf("sub : %d-%d=%d\n",b,a,b-a); 
		printf("mul : %d*%d=%d\n",a,b,a*b); 
		printf("div : %d/%d=%d\n",c,a,c/a); 
		

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
