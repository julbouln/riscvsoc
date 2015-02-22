#include <stdint.h>
#include <stddef.h>

void *malloc(size_t size);
int strcmp(const char* s1, const char* s2);

int time(int *t);
	
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
void serial_out_string(char *s);
int mprintf(const char *format, ...);


#define csr_read(csr)						\
({								\
    register unsigned long __v;                                 \
    __asm__ __volatile__ ("csrr %0, " #csr : "=r" (__v));       \
    __v;							\
})
