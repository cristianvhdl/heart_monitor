/**
 *  Heart Monitor
 *  Author: Michael Kohn
 *   Email: mike@mikekohn.net
 *     Web: http://www.mikekohn.net/
 * License: GPL
 *
 * Copyright 2014 by Michael Kohn
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#import <Foundation/Foundation.h>

#import "HeartMonitorWindow.h"
#import "Serial.h"

int main(int argc, char *argv[])
{
  HeartMonitorWindow *window;
  Serial *serial;
  uint8_t value;

  window = [[HeartMonitorWindow alloc] init];
  serial = [[Serial alloc] init];

  //[serial open:"/dev/ttyUSB0"];
  [serial open:"/dev/ttyACM0"];

  while(1)
  {
    [window draw];
    value = [serial readByte];
    //[window pause];
    [window update:value];
    if ([window shouldQuit]) { break; }
  }

  [serial close];

  return 0;
}

