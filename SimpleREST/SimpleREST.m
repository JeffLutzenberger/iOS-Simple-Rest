//
//  SimpleREST.m
//  SimpleREST
//
//  Created by Jeff Lutzenberger on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimpleREST.h"

@implementation SimpleREST

@synthesize url;
@synthesize logSuccess;
@synthesize logErrors;

- (id)init:(NSString*)urlStr
{
    self = [super init];
    if( self )
    {
        url = [NSString stringWithString:urlStr];
        logSuccess = NO;
        logErrors = NO;
    }
    return self;
}

- (NSDictionary*) Request:(NSString*) httpMethod resource:(NSString*)resource params:(NSDictionary*)params
{
    NSURL *nsurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", url, resource]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    //check method type can be: GET, POST, PUT or DELETE
    [request setHTTPMethod:httpMethod];
    NSHTTPURLResponse* urlResponse = nil;  
    NSError *error = [[NSError alloc] init];  
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];  
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
        if( logSuccess )
        {
            NSLog(@"Response Code: %d", [urlResponse statusCode]);
            NSLog(@"Response: %@", result);
        }
        //deserialize to json
        NSError *jsonParsingError = nil;
        NSDictionary *items = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
        return items;
    }
    else
    {
        if( logErrors )
        {
            NSLog(@"Response Code: %d", [urlResponse statusCode]);
            NSLog(@"Response: %@", result);
            NSLog(@"%@", error.description);
        }
        return Nil;
    }
}

- (NSDictionary*) Get:(NSString*) resource params:(NSDictionary*)params
{
    return [self Request:@"GET" resource:resource params:params];
}

- (NSDictionary*) Post:(NSString*) resource params:(NSDictionary*)params
{
    return [self Request:@"POST" resource:resource params:params];
}

- (NSDictionary*) Put:(NSString*) resource params:(NSDictionary*)params
{
    return [self Request:@"PUT" resource:resource params:params];
}

- (NSDictionary*) Delete:(NSString*) resource params:(NSDictionary*)params
{
    return [self Request:@"DELETE" resource:resource params:params];
}

@end
