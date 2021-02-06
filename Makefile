#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

# Path variable
export DEVKITARM = ~/Documents/Stuff/School/MIE438/Project/devkitPro/devkitARM

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/gba_rules

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing extra header files
# DATA is a list of directories containing binary data
# GRAPHICS is a list of directories containing files to be processed by grit
#
# All directories are specified relative to the project directory where
# the makefile is found
#
#---------------------------------------------------------------------------------
TARGET		:= $(notdir $(CURDIR))
BUILD		:= build
SOURCES		:= asm source resources
INCLUDES	:= include resources
DATA		:= data
MUSIC		:=

COMPILER = $(DEVKITARM)/bin/
TOOLS = $(DEVKITARM)/tools/bin/
OUT = ~/Documents/Stuff/School/MIE438/Project/gba/out/$(FILE)/

# Flags
ARCH	:=	-mthumb -mthumb-interwork

CFLAGS:= -g -Wall -O3 -mcpu=arm7tdmi -mtune=arm7tdmi -fomit-frame-pointer -ffast-math -fno-strict-aliasing $(ARCH)

FILE := pong

compile:
	if [ -d $(OUT) ]; then rm -rf $(OUT); mkdir $(OUT); else mkdir $(OUT); fi

	$(COMPILER)arm-none-eabi-gcc -c src/$(FILE).c -O2 -o $(OUT)$(FILE).o $(CFLAGS)
	$(COMPILER)arm-none-eabi-gcc -v $(OUT)$(FILE).o -specs=gba.specs -o $(OUT)$(FILE).elf $(CFLAGS)
	$(COMPILER)arm-none-eabi-objcopy -v -O binary $(OUT)$(FILE).elf $(OUT)$(FILE).gba
	$(TOOLS)gbafix $(OUT)$(FILE).gba

clean:
	rm -rf $(OUT)
