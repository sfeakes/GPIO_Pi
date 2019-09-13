# define the C compiler to use
CC = gcc

#USE_WIRINGPI := 1

LOG := -D GPIO_LOG_ENABLED
#LOG := -D GPIO_ERR_LOG_DISABELED

#SYSFS := -D GPIO_SYSFS_MODE     # Use file system for everything
#SYSFS := -D GPIO_SYSFS_INTERRUPT # Use filesystem for interrupts
SYSFS :=


LIBS := -lm -lpthread

# debug of not
#DBG = -g -O0 -fsanitize=address -static-libasan
#DBG = -g
DBG = -D GPIO_DEBUG
#DBG =

# define any compile-time flags
GCCFLAGS = -Wall -O3

# add it all together
CFLAGS = $(GCCFLAGS) $(LIBS)

# define the C source files
SRC = GPIO_Pi.c

# Where do we want the files
OUT_DIR = ./bin

# define the executable file 
MAIN = gpio_tools
GMON = $(OUT_DIR)/gpio_monitor
GPIO = $(OUT_DIR)/gpio
#TEST = $(OUT_DIR)/gpio_test

#
# The following part of the makefile is generic; it can be used to 
# build any executable just by changing the definitions above and by
# deleting dependencies appended to the file from 'make depend'
#

.PHONY: depend clean

all:    $(MAIN)
  echo: $(MAIN) have been compiled

gpio_tools: gpio_tool gpio_monitor
#	$(CC) -o $(GPIO) $(DBG) $(SRC) $(CFLAGS) -D GPIO_TOOL $(LOG)
#	$(CC) -o $(GMON) $(DBG) $(SRC) $(CFLAGS) -D GPIO_MONITOR $(LOG)

gpio_tool: $(SRC) | $(OUT_DIR)
	$(CC) -o $(GPIO) $(DBG) $(SRC) $(CFLAGS) -D GPIO_TOOL $(LOG) $(SYSFS)

gpio_monitor: $(SRC) | $(OUT_DIR)
	$(CC) -o $(GMON) $(DBG) $(SRC) $(CFLAGS) -D GPIO_MONITOR $(LOG) $(SYSFS)
	
$(OUT_DIR):
	@mkdir -p $(OUT_DIR)

# Samples

SRCS = $(wildcard ./samples/*.c)
PROGS = $(patsubst %.c,%,$(SRCS))
samples: $(PROGS)

%: %.c
	$(CC) $(CFLAGS) $(LIBS) $(DBG) $(LOG) $(SYSFS) GPIO_Pi.c -I ./ -o $@ $<



clean:
	$(RM) *.o *~ $(GMON) $(GPIO) $(PROGS)


