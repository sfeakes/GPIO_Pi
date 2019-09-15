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
#DBG = -D GPIO_DEBUG
DBG =

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
#  Don't use .o files in the make as GPIO_Pi.c is dependant on flags when compiling the tools.
#  samples (and your project) we don't care about, compile normally. ie re-use GPIO_Pi.o
#

.PHONY: depend clean

all:    $(MAIN)
  echo: $(MAIN) have been compiled

gpio_tools: gpio_tool gpio_monitor
gpio_tool: $(GPIO)
gpio_monitor: $(GMON)

$(GPIO): $(SRC) | $(OUT_DIR)
	$(CC) -o $(GPIO) $(DBG) $(SRC) $(CFLAGS) -D GPIO_TOOL $(LOG) $(SYSFS)

$(GMON): $(SRC) | $(OUT_DIR)
	$(CC) -o $(GMON) $(DBG) $(SRC) $(CFLAGS) -D GPIO_MONITOR $(LOG) $(SYSFS)
	
$(OUT_DIR):
	@mkdir -p $(OUT_DIR)

#
# Samples
#
SRCS = $(wildcard ./samples/*.c)
PROGS = $(patsubst %.c,%,$(SRCS))
samples: $(PROGS)

%: %.c
	$(CC) $(CFLAGS) $(LIBS) $(DBG) $(LOG) $(SYSFS) GPIO_Pi.c -I ./ -o $@ $<



clean:
	$(RM) *.o *~ $(GMON) $(GPIO) $(PROGS)


