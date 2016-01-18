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

#import <Foundation/Foundation.h>

#include <SDL/SDL.h>
#include <SDL/SDL_image.h>

#define SIGNAL_LENGTH 128

@interface HeartMonitorWindow:NSObject
{
  SDL_Surface *screen;
  SDL_Rect background_rect;
  SDL_Rect marker_rect;
  Uint32 clear_color;
  Uint32 marker_color;
  int posx;
  Uint32 dot_colors[SIGNAL_LENGTH];
  int values[SIGNAL_LENGTH];
  //int value;
  int current;
  int index;
}

- (id)init;
- (void)delloc;
- (void)draw;
- (void)pause;
- (void)update:(int)value;
- (bool)shouldQuit;

@end

