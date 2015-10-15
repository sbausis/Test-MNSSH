//
//  RA_SSH_Server.h
//  Test-MNSSH
//
//  Created by Simon Baur on 15/10/15.
//  Copyright (c) 2015 Simon Baur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NMSSH/NMSSH.h>

@interface RA_SSH_Server : NSObject <NMSSHChannelDelegate>

@property NMSSHSession* session;

-(instancetype)initWithHost:(NSString*)host andUsername:(NSString *)username;
-(instancetype)initWithHost:(NSString*)host port:(NSInteger)port andUsername:(NSString*)username;

-(BOOL)test_sftp;
-(BOOL)test_command;
-(BOOL)test_channel;

@end
