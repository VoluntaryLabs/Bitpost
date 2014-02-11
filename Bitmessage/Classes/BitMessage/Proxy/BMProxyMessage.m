//
//  BMProxyMessage.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMProxyMessage.h"
#import "XMLRPCEventBasedParser.h"
#import "NSString+BM.h"

@implementation BMProxyMessage

- (id)init
{
    self = [super init];
    self.username = @"bitmarket";
    self.password = @"87342873428901648473823";
    //self.methodName = @"add";
    //self.parameters = [NSArray arrayWithObjects:@2, @3, nil];
    self.parameters = [NSArray array];
    self.debug = NO;
    return self;
}

- (void)composeRequest
{
    self.requestUrl = [NSURL URLWithString: @"http://127.0.0.1:8442/"];
    self.request = [[XMLRPCRequest alloc] initWithURL:self.requestUrl];
    
    [self composeAuth];
    [self.request setMethod:self.methodName withParameters:self.parameters];

    if (self.debug)
    {
        NSLog(@"Request body: %@", [self.request body]);
    }
}

- (void)composeAuth
{
    NSString *authString = [NSString stringWithFormat:@"%@:%@", self.username, self.password];
    //NSData *data = [[authString dataUsingEncoding: NSUTF8StringEncoding] base64EncodedDataWithOptions:0];
    
    //NSString *auth = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //auth = [@"Basic " stringByAppendingString:auth];
    NSString *auth = [@"Basic " stringByAppendingString:[authString encodedBase64]];
    
    [self.request setValue:auth forHTTPHeaderField: @"Authorization"];
}

/*
- (void)sendAsync
{
    [self composeRequest];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    [manager spawnConnectionWithXMLRPCRequest:self.request delegate: self];
}
*/

- (void)sendSync
{
    [self composeRequest];
    
    NSError *error;
    self.response = [XMLRPCConnection sendSynchronousXMLRPCRequest:self.request error:&error];
    self.error = error;
    
    if (self.debug)
    {
        //NSLog(@"\n\nResponse: %@", self.response);
        NSLog(@"\n\nresponseValue: %@", [self responseValue]);

        if (self.error)
        {
            NSLog(@"\n\nerror %@", self.error);
        }
    }
}

- (id)responseValue
{
    if (self.response)
    {
        return self.response.object;
    }
    
    return nil;
}

- (id)parsedResponseValue
{
    if (self.response)
    {
        NSString *s = self.response.object;
        NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:0
                     error:&error];
        
        if(error)
        {
            self.error = error;
        }

        
        return object;
    }
    
    return nil;
}

/*

 // for asnyc calls
 
 - (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response
{
    NSLog(@"\n\nResponse: %@", response);
}

- (void)request: (XMLRPCRequest *)request didSendBodyData: (float)percent
{
    NSLog(@"didSendBodyData %f", percent);
}

- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error
{
    NSLog(@"didFailWithError %@", error);
}

- (BOOL)request: (XMLRPCRequest *)request
    canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)request: (XMLRPCRequest *)request
    didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"didReceiveAuthenticationChallenge");
}

- (void)request: (XMLRPCRequest *)request
    didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"didCancelAuthenticationChallenge");
}
*/


@end
