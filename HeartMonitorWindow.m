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

#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#import <Foundation/Foundation.h>

#import "HeartMonitorWindow.h"

@implementation HeartMonitorWindow:NSObject

- (id)init
{
  int n;

  self = [super init];

  SDL_Init(SDL_INIT_EVERYTHING);
  SDL_WM_SetCaption("Heart Monitor", NULL);

  screen = SDL_SetVideoMode(640, 480, 32, SDL_SWSURFACE);
  background_rect.x = 0;
  background_rect.y = 0;
  background_rect.w = 640;
  background_rect.h = 480;

  marker_rect.x = 0;
  marker_rect.y = 240;
  marker_rect.w = 640;
  marker_rect.h = 1;

  clear_color = SDL_MapRGB(screen->format, 50, 50, 100);
  marker_color = SDL_MapRGB(screen->format, 100, 100, 100);
  //dot_color = SDL_MapRGB(screen->format, 255, 255, 255);

  posx = 0;
  float dc = (255 - 50) / SIGNAL_LENGTH;
  //value = 240;
  current = 0;
  for (n = 0; n < SIGNAL_LENGTH; n++)
  {
    int a = 255 - (int)(n * dc);
    dot_colors[n] = SDL_MapRGB(screen->format, a, a, a);
    values[n] = 240;
  }

  index = 0;

  return self;
}

- (void)delloc
{
  if (screen != NULL) { SDL_FreeSurface(screen); }
  SDL_Quit();

  [super dealloc];
}

- (void)draw
{
  SDL_Rect dot_rect;
  int n,x,i,y;

  SDL_FillRect(screen, &background_rect, clear_color); 
  SDL_FillRect(screen, &marker_rect, marker_color); 

  dot_rect.w = 2;
  dot_rect.h = 2;

  x = posx;
  i = index;
  for (n = 0; n < SIGNAL_LENGTH; n++)
  {
    dot_rect.x = x;
    dot_rect.y = values[i];

    SDL_FillRect(screen, &dot_rect, dot_colors[n]);

    if (n != 0)
    {
      int old_y = dot_rect.y;
      y = values[i + 1];
      //dy = (y - dot_rect.y) < 0 ? 1 : -1;

      if (y < old_y && y != 0 && old_y != 0)
      {
        while(YES)
        {
          y += 2;
          if (y >= old_y) { break; }
          dot_rect.y = y;
          SDL_FillRect(screen, &dot_rect, dot_colors[n]);
        }
      }
      else if (y > old_y)
      {
        while(YES)
        {
          y -= 2;
          if (y <= old_y) { break; }
          dot_rect.y = y;
          SDL_FillRect(screen, &dot_rect, dot_colors[n]);
        }
      }
    }

    x--;
    i--;
    if (x < 0) { x += 640; }
    if (i < 0) { i += SIGNAL_LENGTH; }
  }

  posx += 1;
  if (posx >= 640) { posx = 0; }

  SDL_Flip(screen);
}

- (void)pause
{
  SDL_Delay(30);
}

- (void)update:(int)value;
{
  values[index++] = 240 + (value - 128);
  if (index >= SIGNAL_LENGTH) { index = 0; }
}

- (bool)shouldQuit
{
  SDL_Event event;

  SDL_PollEvent(&event);
  if (event.type == SDL_QUIT) { return YES; }

  return NO;
}

@end


