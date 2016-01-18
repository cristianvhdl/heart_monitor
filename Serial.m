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

#include <termios.h>
#include <unistd.h>
#include <fcntl.h>

#import <Foundation/Foundation.h>

#import "Serial.h"

@implementation Serial:NSObject

- (id)init
{
  self = [super init];

  return self;
}

- (void)delloc
{
  [super dealloc];
}

- (int)open:(char *)device
{
  printf("Opening %s\n", device);

  fd = open(device, O_RDWR|O_NOCTTY);
  if (fd == -1)
  {
    printf("Couldn't open serial device.\n");
    exit(1);
  }

  tcgetattr(fd,&oldtio);

  memset(&newtio, 0, sizeof(struct termios));
  newtio.c_cflag = B9600|CS8|CLOCAL|CREAD;
  newtio.c_iflag = IGNPAR;
  newtio.c_oflag = 0;
  newtio.c_lflag = 0;
  newtio.c_cc[VTIME] = 0;
  newtio.c_cc[VMIN] = 1;

  tcflush(fd, TCIFLUSH);
  tcsetattr(fd, TCSANOW, &newtio);

  return 0;
}

- (int)send:(char *)packet
{
  int len = strlen(packet);
  int n = 0;

  while(n < len)
  {
    int count = write(fd, packet, len - n);
    n = n + count;
  }

  return 0;
}

- (uint8_t)readByte
{
  uint8_t ch;
  int count;

  count = read(fd, &ch, 1);

  if (count == 0) { return 0; } // Oh yeah, useful. Thanks GCC.

  return ch;
}

- (void)close
{
  close(fd);
  tcsetattr(fd, TCSANOW, &oldtio);
}

@end

