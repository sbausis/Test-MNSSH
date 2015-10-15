//
//  RA_SSH_Server.m
//  Test-MNSSH
//
//  Created by Simon Baur on 15/10/15.
//  Copyright (c) 2015 Simon Baur. All rights reserved.
//

#import "RA_SSH_Server.h"

@implementation RA_SSH_Server

@synthesize session = _session;
-(void)setSession:(NMSSHSession *)session {
    if (_session && _session.isConnected) {
        [_session disconnect];
    }
    _session = session;
}
-(NMSSHSession*)session {
    if (!_session) {
        if (!(_session =[[NMSSHSession alloc] init])) {
            return Nil;
        }
    }
    if (!_session.isConnected) {
        if (![_session connectWithTimeout:[NSNumber numberWithInt:10]]) {
            NSLog(@"Could not connect to Host ...");
            return Nil;
        }
    }
    if (!_session.isAuthorized) {
        if (![_session authenticateByPassword:@"testpass"]) {
            NSLog(@"Could not authenticate ...");
            return Nil;
        }
    }
    return _session;
}

-(instancetype)initWithHost:(NSString*)host andUsername:(NSString *)username {
    self = [super init];
    if (self) {
        self.session = [[NMSSHSession alloc] initWithHost:host andUsername:username];
    }
    return self;
}

-(instancetype)initWithHost:(NSString*)host port:(NSInteger)port andUsername:(NSString*)username {
    self = [super init];
    if (self) {
        self.session = [[NMSSHSession alloc] initWithHost:host port:port andUsername:username];
    }
    return self;
}

-(BOOL)test_sftp {
    BOOL success = FALSE;
    
    NMSSHSession *session = self.session;
    if (session) {
        
        if ([session.sftp connect]) {
            
            NSArray *remoteFileList = [session.sftp contentsOfDirectoryAtPath:@"/"];
            for (NMSFTPFile *file in remoteFileList) {
                NSLog(@"%@", file.filename);
            }
            success = ([remoteFileList count]>0);
            
        }
        
        if (session.sftp.isConnected) {
            [session.sftp disconnect];
        }
        
    }
    
    return success;
}

-(BOOL)test_command {
    BOOL success = FALSE;
    
    NMSSHSession *session = self.session;
    if (session) {
        
        NSError *error = Nil;
        NSString *response = [session.channel execute:@"uname -a" error:&error];
        NSLog(@"uname: %@", response);
        
        success = (error == Nil);
    }
    
    return success;
}

@end
