
PROGRAM=heart_monitor
INCLUDE=/storage/git/naken_asm/include
ASM=naken_asm
CFLAGS=-Wall $(INCLUDES) -g
LDFLAGS=`fltk-config --libs --ldflags`
OBJCFLAGS=`gnustep-config --objc-flags` -lgnustep-base

default: sdl
	$(ASM) -l -o $(PROGRAM).hex -I$(INCLUDE) $(PROGRAM).asm

sdl:
	gcc -c -x objective-c HeartMonitorWindow.m -g -Wall -O3 $(OBJCFLAGS)
	gcc -c -x objective-c Serial.m -g -Wall -O3 $(OBJCFLAGS)
	gcc -o heart_monitor HeartMonitorWindow.o Serial.o \
	  -x objective-c heart_monitor.c -g -Wall -O3 $(OBJCFLAGS) -lobjc \
	  `sdl-config --cflags --libs`

clean:
	@rm -f *.hex *.lst *.ndbg *.o *.d heart_monitor
	@echo "Clean!"

