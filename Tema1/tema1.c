#include <unistd.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int write_stdout(const char *token, int length)
{
	int rc;
	int bytes_written = 0;

	do {
		rc = write(1, token + bytes_written, length - bytes_written);
		if (rc < 0)
			return rc;

		bytes_written += rc;
	} while (bytes_written < length);

	return bytes_written;
}

// inverseaza un string
void reverse(char s[])
 {
    int i, j;
    char c;

    for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}

// functie care transforma un int intr-un string, din C Programming Language,
// 2nd edition
void itoa(long n, char s[])
 {
    int i, sign;

    if ((sign = n) < 0)  /* record sign */
        n = -n;    /* make n positive */
    i = 0;
    do {       /* generate digits in reverse order */
        s[i++] = n % 10 + '0';   /* get next digit */
    } while ((n /= 10) > 0);     /* delete it */
    if (sign < 0)
    	s[i++] = '-';
    s[i] = '\0';
    reverse(s);
}

//functia care transforma un unsigned int in string, pe modelul functiei itoa
void utoa(int n, char s[])
{
	int i; 
	unsigned int noSign;

    if (n < 0){
    	noSign = 4294967295 + n + 1;  // transformare n in unsigned
    }
    else
    	noSign = n;
    i = 0;
    do {       /* generate digits in reverse order */
    	s[i++] = noSign % 10 + '0';   /* get next digit */
    } while ((noSign /= 10) > 0);     /* delete it */
    s[i] = '\0';
    reverse(s);
}

// functie care transforma un int in hexa si il retine intr-un string
int print_hexa(int n){
	unsigned int noSign;
	int count = 0;
	char s[10];
    if (n < 0){
    	noSign = 4294967295 + n + 1;  // transformare n in unsigned
    }
    else
    	noSign = n;

    while(noSign > 0){
    	if(noSign % 16 < 10)
    		s[count] = noSign % 16 + '0';
    	else if(noSign % 16 >= 10)
    		s[count] = noSign % 16 - 10 + 'a';
    	count++;
    	noSign /= 16;
    }
    s[count] = '\0';
    reverse(s);
    write_stdout(s, count);
    return count;
}

// functia imita comportamentul lui printf
int iocla_printf(const char *format, ...)
{
	va_list args;
	int count = 0;  //numara cate caractere au fost afisate
	va_start(args, format);
	// parcurge sirul de caractere format
	while(*format != '\0'){
		// verifica daca % apare o singura data si cauta specificatorul
		if(*format == '%' && *(format + 1) != '%')  
		{
			if(*(++format) == 'd')
			{
				char buffer[11];  // string-ul in care se va afla int-ul
				itoa(va_arg(args, int), buffer);  // transforma int-ul
				write_stdout(buffer, strlen(buffer));
				count += strlen(buffer);
			}
			else if(*format == 'u')
			{
				char buffer[11];
				utoa(va_arg(args, int), buffer);
				write_stdout(buffer, strlen(buffer));
				count += strlen(buffer);
			}
			else if(*format == 'x')
				count += print_hexa(va_arg(args, int));
			else if(*format == 'c')
			{
				count++;
				char c = va_arg(args, int);
				write_stdout(&c, 1);
			}
			else if(*format == 's')
			{
				char *s = va_arg(args, char*);
				count += strlen(s);
				write_stdout(s, strlen(s));
			}
		}
		// daca % apare de 2 ori la rand va afisa un %
		else if(*format == '%')
		{
			count++;
			write_stdout(++format, 1);
		}
		// daca "\" apare de 2 ori, va afisa "\" si caracterul care il urmeaza
		else if(*format == '\\')
		{
			write_stdout(format++, 2);
			count += 2;
		}
		else
		{
			count++;
			write_stdout(format, 1);
		}
		format++;
	}

	return count;
}