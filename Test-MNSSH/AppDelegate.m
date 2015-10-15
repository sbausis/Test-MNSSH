//
//  AppDelegate.m
//  Test-MNSSH
//
//  Created by Simon Baur on 14/10/15.
//  Copyright (c) 2015 Simon Baur. All rights reserved.
//

#import "AppDelegate.h"

#define REMOTE_HOST @"192.168.1.3"
#define REMOTE_PORT 22
#define REMOTE_USER @"testuser"
#define REMOTE_PASS @"testpass"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    self.server = [[RA_SSH_Server alloc] initWithHost:REMOTE_HOST port:REMOTE_PORT andUsername:REMOTE_USER];
    if (self.server) {
        
        //[self.server test_sftp];
        //[self.server test_command];
        [self.server test_channel];
        
        self.server.session = Nil;
    }
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)test_SSH_Session {
    BOOL success = FALSE;
    
    NMSSHSession *session = [NMSSHSession connectToHost:REMOTE_HOST
                                           withUsername:REMOTE_USER];
    if (session.isConnected) {
        
        [session authenticateByPassword:REMOTE_PASS];
        if (session.isAuthorized) {
            
            NSLog(@"Authentication succeeded");
            
            NSError *error = nil;
            NSString *response = [session.channel execute:@"ls -l /var/www/" error:&error];
            NSLog(@"List of my sites: %@", response);
            
            success = [session.channel uploadFile:@"~/index.html" to:@"/var/www/9muses.se/"];
        }
        
        [session disconnect];
    }
    
    return success;
}

- (BOOL)test_get_file_list {
    BOOL success = FALSE;
    
    NMSSHSession *session = [[NMSSHSession alloc] initWithHost:REMOTE_HOST andUsername:REMOTE_USER];
    [session connect];
    if (session.isConnected) {
        
        [session authenticateByPassword:REMOTE_PASS];
        if (session.isAuthorized) {
            
            [session.sftp connect];
            
            NSArray *remoteFileList = [session.sftp contentsOfDirectoryAtPath:@"/"];
            for (NMSFTPFile *file in remoteFileList) {
                NSLog(@"%@", file.filename);
            }
            success = ([remoteFileList count]>0);
        }
        
        [session disconnect];
    }
    
    return success;
}

@end
