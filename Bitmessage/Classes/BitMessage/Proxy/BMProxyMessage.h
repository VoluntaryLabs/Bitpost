//
//  BMProxyMessage.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLRPC.h"

@interface BMProxyMessage : NSObject // <XMLRPCConnectionDelegate>

@property (retain, nonatomic) NSString *host;
@property (assign) int port;

@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSURL *requestUrl;
@property (retain, nonatomic) NSString *methodName;
@property (retain, nonatomic) NSArray *parameters;
@property (retain, nonatomic) XMLRPCRequest *request;
@property (retain, nonatomic) XMLRPCResponse *response;
@property (retain, nonatomic) NSError *error;
@property (assign) BOOL debug;

- (void)composeRequest;
- (void)sendSync;

- (id)responseValue;
- (id)parsedResponseValue;

@end
