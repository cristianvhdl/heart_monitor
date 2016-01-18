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
#include <termios.h>

#import <Foundation/Foundation.h>

@interface Serial:NSObject
{
  int fd;
  struct termios oldtio;
  struct termios newtio;
}

- (id)init;
- (void)delloc;
- (int)open:(char *)device;
- (int)send:(char *)packet;
- (uint8_t)readByte;
- (void)close;

@end

