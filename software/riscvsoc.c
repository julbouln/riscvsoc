#include <stdint.h>
#include <stdarg.h>
#include <stddef.h>

#include "riscvsoc.h"

// should give terrible performance
#ifndef M_EXTENSION
uint32_t __umodsi3(uint32_t num, uint32_t den)
{
	uint32_t quot = 0, qbit = 1;
	while ((int32_t) den >= 0)
	{
		den <<= 1;
		qbit <<= 1;
	}
	while (qbit)
	{
		if (den <= num)
		{
			num -= den;
			quot += qbit;
		}
		den >>= 1;
		qbit >>= 1;
	}
	return num;
}

uint32_t __udivsi3(uint32_t num, uint32_t den)
{
	uint32_t quot = 0, qbit = 1;
	
	while ((int32_t) den >= 0)
	{
		den <<= 1;
		qbit <<= 1;
	}
	
	while (qbit)
	{
		if (den <= num)
		{
			num -= den;
			quot += qbit;
		}
		den >>= 1;
		qbit >>= 1;
	}
	return quot;
}

uint32_t __mulsi3 (uint32_t a, uint32_t b)
{
	uint32_t r = 0;
	while (a)
	{
		if (a & 1)
		{
			r += b;
		}
		b <<= 1;
		a >>=1;
	}
	return r;
}
#endif
/* TIMING */

/*
char *malloc_ptr;
void *malloc(size_t size)
{
  void *ret;
  ret = (void*)malloc_ptr;
  malloc_ptr += size;
  return ret;
}


int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1==*s2))
        s1++,s2++;
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
*/
#define TIME_TICK 100000 // 50Mhz

int time(int *t) {
	return csr_read(time);
}

void delay(int ms)
{
	int t=csr_read(time)+(ms*TIME_TICK);
	while(csr_read(time) < t);
}

/* GPIO */

void gpio_mode(uint8_t pin, uint8_t mode)
{	
	if(mode)
		GPIO_CTRL	|= 1 << pin;
	else
		GPIO_CTRL	&= ~(1 << pin);
}

void gpio_write(uint8_t pin, uint8_t value)
{
	if(value)
		GPIO_PORT	|= 1 << pin;
	else
		GPIO_PORT	&= ~(1 << pin);
}

uint8_t gpio_read(uint8_t pin)
{	
	return GPIO_PORT & (1 << pin);
}

/* UART */

void serial_out_char(char ch)
{
   while (SERIAL_WRITESIZE == 0)
        ;
    SERIAL_DATA = ch;
}

char serial_in_char(void)
{
    if (SERIAL_READSIZE)
	    return SERIAL_DATA;
	else
		return -1;
}

void serial_out_string(char *s)
{
    while (*s)
        serial_out_char(*s++);
}

/*
	This part come from http://www.menie.org/georges/embedded/printf-stdarg.html 

	Copyright 2001, 2002 Georges Menie (www.menie.org)
	stdarg version contributed by Christian Ettinger

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#define putchar(c) serial_out_char(c)

static void printchar(char **str, int c)
{
	if (str) {
		**str = c;
		++(*str);
	}
	else putchar(c);
}

#define PAD_RIGHT 1
#define PAD_ZERO 2

static int prints(char **out, const char *string, int width, int pad)
{
	register int pc = 0, padchar = ' ';

	if (width > 0) {
		register int len = 0;
		register const char *ptr;
		for (ptr = string; *ptr; ++ptr) ++len;
		if (len >= width) width = 0;
		else width -= len;
		if (pad & PAD_ZERO) padchar = '0';
	}
	if (!(pad & PAD_RIGHT)) {
		for ( ; width > 0; --width) {
			printchar (out, padchar);
			++pc;
		}
	}
	for ( ; *string ; ++string) {
		printchar (out, *string);
		++pc;
	}
	for ( ; width > 0; --width) {
		printchar (out, padchar);
		++pc;
	}

	return pc;
}

/* the following should be enough for 32 bit int */
#define PRINT_BUF_LEN 12

static int printi(char **out, int i, int b, int sg, int width, int pad, int letbase)
{
	char print_buf[PRINT_BUF_LEN];
	register char *s;
	register int t, neg = 0, pc = 0;
	register unsigned int u = i;

	if (i == 0) {
		print_buf[0] = '0';
		print_buf[1] = '\0';
		return prints (out, print_buf, width, pad);
	}

	if (sg && b == 10 && i < 0) {
		neg = 1;
		u = -i;
	}

	s = print_buf + PRINT_BUF_LEN-1;
	*s = '\0';

	while (u) {
		t = u % b;
		if( t >= 10 )
			t += letbase - '0' - 10;
		*--s = t + '0';
		u /= b;
	}

	if (neg) {
		if( width && (pad & PAD_ZERO) ) {
			printchar (out, '-');
			++pc;
			--width;
		}
		else {
			*--s = '-';
		}
	}

	return pc + prints (out, s, width, pad);
}

static int print(char **out, const char *format, va_list args )
{
	register int width, pad;
	register int pc = 0;
	char scr[2];

	for (; *format != 0; ++format) {
		if (*format == '%') {
			++format;
			width = pad = 0;
			if (*format == '\0') break;
			if (*format == '%') goto out;
			if (*format == '-') {
				++format;
				pad = PAD_RIGHT;
			}
			while (*format == '0') {
				++format;
				pad |= PAD_ZERO;
			}
			for ( ; *format >= '0' && *format <= '9'; ++format) {
				width *= 10;
				width += *format - '0';
			}
			if( *format == 's' ) {
				register char *s = (char *)va_arg( args, int );
				pc += prints (out, s?s:"(null)", width, pad);
				continue;
			}
			if( *format == 'd' ) {
				pc += printi (out, va_arg( args, int ), 10, 1, width, pad, 'a');
				continue;
			}
			if( *format == 'x' ) {
				pc += printi (out, va_arg( args, int ), 16, 0, width, pad, 'a');
				continue;
			}
			if( *format == 'X' ) {
				pc += printi (out, va_arg( args, int ), 16, 0, width, pad, 'A');
				continue;
			}
			if( *format == 'u' ) {
				pc += printi (out, va_arg( args, int ), 10, 0, width, pad, 'a');
				continue;
			}
			if( *format == 'c' ) {
				/* char are converted to int then pushed on the stack */
				scr[0] = (char)va_arg( args, int );
				scr[1] = '\0';
				pc += prints (out, scr, width, pad);
				continue;
			}
		}
		else {
		out:
			printchar (out, *format);
			++pc;
		}
	}
	if (out) **out = '\0';
	va_end( args );
	return pc;
}

int mprintf(const char *format, ...)
{
        va_list args;
        
        va_start( args, format );
        return print( 0, format, args );
}

int msprintf(char *out, const char *format, ...)
{
        va_list args;
        
        va_start( args, format );
        return print( &out, format, args );
}

/* SPI */
#define SPI_REG (*(volatile uint32_t *)0x82000000)
#define SPI_START 0x01
#define SPI_BUSY 0x02
#define SPI_NEW_DATA 0x04

void spi_init() {
	SPI_REG=0;
}

void spi_write(char data) {
	SPI_REG = ((SPI_START << 8) | data);
	while(SPI_REG & (SPI_BUSY << 8));
}

char spi_read() {
	char data;
	while(!(SPI_REG & (SPI_NEW_DATA << 8)));
	data=SPI_REG & 0xFF;
	return data;
}

