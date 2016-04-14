//
//  AppDelegate.m
//  AutoLaunchHelper
//
//  Created by Jason Zheng on 4/14/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
  pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 4)];
  NSString *path = [NSString pathWithComponents:pathComponents];
  [[NSWorkspace sharedWorkspace] launchApplication:path];
  [NSApp terminate:nil];
}

@end
