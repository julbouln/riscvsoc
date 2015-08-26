#include <stdint.h>
#include <stddef.h>

//#include "alloc.h"

#define SERIAL_DATA		(*(volatile unsigned char *)0x80000000)
#define SERIAL_READSIZE		(*(volatile unsigned short *)0x80000002)
#define SERIAL_WRITESIZE	(*(volatile unsigned short *)0x80000006)

#define GPIO_PORT (*(volatile unsigned char *)0x81000000)
#define GPIO_CTRL (*(volatile unsigned char *)0x81000004)

//void *malloc(size_t size);
int strcmp(const char* s1, const char* s2);

long time();
	
/* TIMING */
void delay(int ms);

/* GPIO */
#define INPUT 0
#define OUTPUT 1
#define LOW 0
#define HIGH 1

void gpio_mode(uint8_t pin, uint8_t mode);
void gpio_write(uint8_t pin, uint8_t value);
uint8_t gpio_read(uint8_t pin);

/* UART */

char serial_in_char(void);

void serial_out_char(char c);
void serial_out_string(char *s);
int printf(const char *format, ...);


#define csr_read(csr)						\
({								\
    register unsigned long __v;                                 \
    __asm__ __volatile__ ("csrr %0, " #csr : "=r" (__v));       \
    __v;							\
})
