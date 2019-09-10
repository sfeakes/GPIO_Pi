
# GPIO Pi
Embedded GPIO Library to control Raspberry Pi's GPIO ports<br>
Some/Most of this was borrowd from http://wiringpi.com, so all credit goes to Gordon who created WiringPi.

* <b>This is designed to be small and very efficient C GPIO Library for embedded applications, and NOTHING else</b>
# Reason for being

I developed this a long time ago for a few projects of my own. I did startoff using Wiring PI, it worked well for a number of years, it is a super solid and a very well written library, but there were a few things that just didn't work for me, so I wrote GPIO pi. I never released this code as a stand-alone repo as Wiring Pi was a far better option for most developers, and all the software I did release that used GPIO pi always had compile flags to pick between Wiring Pi ot GPIO pi. But since Wiring Pi is now depreciated http://wiringpi.com/wiringpi-deprecated/, I decided to realse GPIO pi.

The reason I developed this over using WiringPi, I wanted Small and a set of functions compile into code that just did GPIO setup, GPIO read/write & GPIO triggers for embedded style systems, and absolutly nothing else.<br>
The main differances.<br>
- Wiring Pi was designed to be a dynamic linked library.
  - GPIO Pi is 2 files designed to be compiled with your source code.
- Wiring Pi was always a bit hairy to setup output pins on system boot without bouncing the pin (not good if using realy boards to control sprinklers or garage doors).
  - GPIO Pi is designed to do this, so no shutting/opening the garage door on system reboot.
- Wiring Pi didn't support any pointers in the trigger calback functions. (real pain if using a generic function for all trigers).
  - GPIO Pi allows you to pass pointer into callback functions.
- Wiring Pi ended up supporting a ton of "things", way beyond basic GPIO control.
  - GPIO Pi just supports basic GPIO control, and will never do anything else.

Most function signitures and constants are identical to Wiring Pi, makeing compiling between the two as simply as pissible.<br>
Some of the code was simply cut n pate from Wiring Pi, and other parts use the logic or Wiring Pi, so the credit for this must go to Goron from Wiring Pi. 

# Notes

- This is a C GPIO library for Raspberry Pi's.<br>
- I will not modify this for other Pi clones.<br>
- If you are looking for a Python / Node library, you don't need one, you can simply use the simply use the Pi's file system to read and write to GPIO pins. Read up on '/sys/class/gpio' on the Pi. OK, So this is faster as it uses memory address rather than the file system, but speed isn't important since your using Python or Node.
- If you're looking for some tools to do GPIO control with bash/csh/sh scripts, then the supplied gpio & gpio_monitor are perfect for you.

# TL;DR Install
get the repo, or GPIO_pi.c and GPIO_pi.h, copy it to your project and compile against it.

This repo does also come with a Make file that will create a few usefull tools.<br>
Running Make will net you two binary files. `gpio` & `gpio_monitor`<br>
use `gpio` to read, write & set GPIO options.<br>
use `gpio_monitor` to monitor all pins and print events.

Compile flags :-

- GPIO_LOG_ENABLED
  - Enable status logging, will log to stdout and syslog

- GPIO_ERR_LOG_DISABELED
  - Disable error messages beging printed to stderr and syslog

- GPIO_SYSFS_MODE
  - By default GPIO Pi will use the memory address to read/write to GPIO pins, enabeling this will make GPIO Pi use the filesystem.

# Usage

Notes :-
gpio = GPIO number, not physical pin number.
Most function signitures and constants are identical to Wiring Pi, makeing compiling between the two as simply as pissible. The only differance is registerGPIOinterrupt() has an extra parameter, gpioShutdown() is an added function and wiringPiSetup() is gpioSetup() 

## Basic functions

- <b>bool gpioSetup();</b>
  - Setup GPIO Pi
  - Good return = `true`
- <b>void gpioShutdown();</b>
  - Shutdown service
- <b>int pinMode(unsigned gpio, unsigned mode);</b>
  - Set GPIO mode, (input or output)
  - gpio = GPIO Pin number.  ie 4 for GPIO4 physical pin #7
  - mode = INPUT or OUTPUT
  - Return >0 on failure , `true` on good.
- <b>int getPinMode(unsigned gpio);</b>
  - Get GPIO mode
  - Return >0 on failure , `INPUT` or `OUTPUT` (0 or 1).
- <b>int setPullUpDown(unsigned gpio, unsigned pud);</b>
  - gpio = GPIO Pin number.  ie 4 for GPIO4 physical pin #7
  - Set pull up / pull down resistor,
  - pud = `PUD_OFF`, `PUD_DOWN`, `PUD_UP`
  - Return >0 on failure , true good.
- <b>int digitalRead(unsigned gpio);</b>
  - gpio = GPIO Pin number.  ie 4 for GPIO4 physical pin #7                  
  - Read from GPIO
  - Return >0 on failure `LOW` = pin low or 0, `HIGH` = pin high or 1
- <b>int digitalWrite(unsigned gpio, unsigned level);</b>
  - gpio = GPIO Pin number.  ie 4 for GPIO4 physical pin #7 
  - Write to GPIO  
  - level = `LOW` or `HIGH`.
  - Return >0 on failure.
- <b>bool registerGPIOinterrupt(int gpio, int mode, void (*function)(void *args), void *args );</b>
  - Register a function to be called when a state has changed on a pin.
  - gpio = GPIO Pin number.  ie 4 for GPIO4 physical pin #7
  - mode = `INT_EDGE_SETUP`, `INT_EDGE_FALLING`, `INT_EDGE_RISING`, `INT_EDGE_BOTH`
  - function = function name, should be defined as `void *myCallBack(void * args)`
  - args = pointer to be passed to function.

## Return Errors are :-
- GPIO_ERR_GENERAL    -5
- GPIO_NOT_OUTPUT     -6
- GPIO_NOT_EXPORTED   -4
- GPIO_ERR_IO         -3
- GPIO_ERR_NOT_SETUP  -2
- GPIO_ERR_BAD_PIN    -1
- GPIO_OK              0
- All int returns (0 or 1) are good returns.  1 = HIGH, 0 = LOW (or OK), depending on function.
- Bool returns are self explanatory

## Extended functions

- bool pinExport(unsigned gpio);
- bool pinUnexport(unsigned gpio);
- bool isExported(unsigned gpio);
- int edgeSetup (unsigned int pin, unsigned int value);

## Constants

- INPUT             = 0
- OUTPUT            = 1
- LOW               = 0
- HIGH              = 1
- INT_EDGE_SETUP	= 0
- INT_EDGE_FALLING	= 1
- INT_EDGE_RISING	= 2
- INT_EDGE_BOTH		= 3
- PUD_OFF			= 0
- PUD_DOWN		    = 1
- PUD_UP			= 2

# Version

1.0 Initial Release
