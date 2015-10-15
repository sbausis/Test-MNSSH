//
//  AppDelegate.h
//  Test-MNSSH
//
//  Created by Simon Baur on 14/10/15.
//  Copyright (c) 2015 Simon Baur. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RA_SSH_Server.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property RA_SSH_Server* server;

@end

