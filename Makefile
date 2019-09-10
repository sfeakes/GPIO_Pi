# define the C compiler to use
CC = gcc

#USE_WIRINGPI := 1

LOG := -D GPIO_LOG_ENABLED
#LOG := -D GPIO_ERR_LOG_DISABELED


LIBS := -lm -lpthread

# debug of not
#DBG = -g -O0 -fsanitize=address -static-libasan
#DBG = -g
DBG =

# define any compile-time flags
GCCFLAGS = -Wall -O3

# add it all together
CFLAGS = $(GCCFLAGS) $(LIBS) $(LOG) 

# define the C source files
SRC = GPIO_Pi.c

# define the executable file 
MAIN = gpio_tools
GMON = ./gpio_monitor
GPIO = ./gpio
TEST = ./gpio_test

#
# The following part of the makefile is generic; it can be used to 
# build any executable just by changing the definitions above and by
# deleting dependencies appended to the file from 'make depend'
#

.PHONY: depend clean

all:    $(MAIN) $(TEST)
  @echo: $(MAIN) have been compiled

gpio_tools: $(SRC)
	$(CC) -o $(GPIO) $(DBG) $(SRC) $(CFLAGS) -D GPIO_TOOL $(LOG)
	$(CC) -o $(GMON) $(DBG) $(SRC) $(CFLAGS) -D GPIO_MONITOR $(LOG)

gpio_test: gpio_pi_sample.c $(SRC)
	$(CC) -o $(TEST) $(DBG) gpio_pi_sample.c $(SRC) $(CFLAGS) -D GPIO_LOG_ENABLED

clean:
	$(RM) *.o *~ $(GMON) $(GPIO)


