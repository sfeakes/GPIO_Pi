#include <stdio.h>
#include <unistd.h>

#include "GPIO_Pi.h"

#define PIN  17
//#define PIN  18
#define POUT  27

void *myCallBack(void * args) {
  printf("GPIO triggered\n");
  int *pin = (int *)args;
	//struct threadGPIOinterupt *stuff = (struct threadGPIOinterupt *) args;
	printf("\tPin callback on GPIO triggered %d, value=%d\n",*pin,digitalRead(*pin));

  return NULL;
}


#ifndef GPIO_SYSFS_MODE
// If we are NOT in susfs mode

int main(int argc, char *argv[]) {

  int repeat = 3;
  int p_in = PIN;
  int p_out = POUT;

  gpioSetup();

  if (pinMode(p_out, OUTPUT) < 0 || pinMode(p_in, INPUT) < 0)
    return (2);

  if (registerGPIOinterrupt(p_in, INT_EDGE_BOTH, (void *)&myCallBack, (void *)&p_in ) != true)
	  printf("Error registering interupt\n");
  
	if (registerGPIOinterrupt(p_out, INT_EDGE_BOTH, (void *)&myCallBack, (void *)&p_out ) != true)
	  printf("Error registering interupt\n");
	
  do {
    printf ("--------------\n");
		printf("Writing %d to GPIO %d\n", repeat % 2, p_out);
    if (-1 == digitalWrite(p_out, repeat % 2))
      return (3);

    printf("Read %d from GPIO %d (input)\n", digitalRead(p_in), p_in);
    printf("Read %d from GPIO %d (output)\n", digitalRead(p_out), p_out);

    usleep(500 * 1000);
  } while (repeat--);

  printf ("--------------\n");
  pinMode(p_in, OUTPUT);
  printf("Writing %d to GPIO %d\n", !digitalRead(p_in), p_in);
  digitalWrite(p_in, !digitalRead(p_in));

  sleep(1);

  gpioShutdown();

  sleep(1);

  return (0);
}

# else

int main(int argc, char *argv[]) {

  int repeat = 3;
  int p_in = PIN;
  int p_out = POUT;
  
  gpioSetup();

	pinUnexport(p_out);
	pinUnexport(p_in);
	pinExport(p_out);
	pinExport(p_in);

  sleep(1);

  if (pinMode(p_out, OUTPUT) < 0 || pinMode(p_in, INPUT) < 0)
    return (2);

  sleep(1);

  if (registerGPIOinterrupt(p_in, INT_EDGE_BOTH, (void *)&myCallBack, (void *)&p_in ) != true)
	  printf("Error registering interupt\n");
  
	if (registerGPIOinterrupt(p_out, INT_EDGE_BOTH, (void *)&myCallBack, (void *)&p_out ) != true)
	  printf("Error registering interupt\n");
	
  do {
    printf ("--------------\n");
		printf("Writing %d to GPIO %d\n", repeat % 2, p_out);
    if (-1 == digitalWrite(p_out, repeat % 2))
      return (3);

    printf("Read %d from GPIO %d (input)\n", digitalRead(p_in), p_in);
    printf("Read %d from GPIO %d (output)\n", digitalRead(p_out), p_out);

    usleep(500 * 1000);
  } while (repeat--);

  gpioShutdown();

  if (-1 == pinUnexport(p_out) || -1 == pinUnexport(p_in))
    return (4);

  sleep(1);

  return (0);
}

#endif