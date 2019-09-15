#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "GPIO_Pi.h"

#define PL1  17
#define PL2  27

void *myCallBack(void * args) {

  int *pin = (int *)args;
  int other_pin;

  if (*pin == PL1) {
    other_pin = PL2;
  } else {
    other_pin = PL1;
  }
    
	printf("\t(%s) - GPIO %d triggered with value=%d, writing %d to GPIO %d\n",(*pin==PL1?"PING":"PONG"),*pin,digitalRead(*pin),!digitalRead(other_pin),other_pin);
  
  sleep(1);

  digitalWrite(other_pin, !digitalRead(other_pin));

  return NULL;
}

void error(char *msg) {
  fprintf(stderr, "Error: %s\n",msg);
  gpioShutdown();
  exit(1);
}

int main(int argc, char *argv[]) {
  int pl1 = PL1;
  int pl2 = PL2;

  gpioSetup();

  // Store current mode so we can reset when finished.
  int p1mode = getPinMode(pl1);
  int p2mode = getPinMode(pl2);

  if (pinMode(pl1, OUTPUT) < 0)
    error("Couldn't set PL1 to output\n");

  if (pinMode(pl2, OUTPUT) < 0)
    error("Couldn't set PL1 to output\n");

  if (registerGPIOinterrupt(pl1, INT_EDGE_BOTH, (void *)&myCallBack, (void *) &pl1) != GPIO_OK)
	  error("Error registering interupt\n");
  
	if (registerGPIOinterrupt(pl2, INT_EDGE_BOTH, (void *)&myCallBack, (void *) &pl2) != GPIO_OK)
	  error("Error registering interupt\n");

  sleep(1);

  // Start the ping pong
  if ( digitalWrite(pl1, !digitalRead(pl1)) < 0 ) {
    printf("OK That's didn't work\n");
  }

  // Let the ping pong take place
  sleep(5);

  printf("I'm board of this!, exiting\n");

  // Reset pin modes 
  pinMode(pl1, p1mode);
  pinMode(pl2, p2mode);

  gpioShutdown();
  sleep(1);
  
  return 0;
}