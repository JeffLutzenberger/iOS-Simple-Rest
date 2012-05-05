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

- (NSDictionary*) SendRequest:(NSMutableURLRequest*) request
{
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
    NSString *paramStr = @"";
    bool first = true;
    for (NSString* key in params) {
        if( first ){
            paramStr = [NSString stringWithFormat:@"%@?%@=%@", paramStr, (NSString*)key, (NSString*)[params objectForKey:key]];
            first = false;
        }else {
            paramStr = [NSString stringWithFormat:@"%@&%@=%@", paramStr, (NSString*)key, (NSString*)[params objectForKey:key]];
        }
    }
    
    NSURL *nsurl = [NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@%@", url, resource, paramStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    [request setHTTPMethod:@"GET"];

    return [self SendRequest:request];
}

- (NSDictionary*) Post:(NSString*) resource params:(NSDictionary*)params
{
    NSURL *nsurl = [NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@", url, resource] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    [request setHTTPMethod:@"POST"];
    NSString *post = @"";
    bool first = true;
    for (NSString* key in params) {
        if( first ){
            post = [NSString stringWithFormat:@"%@=%@", (NSString*)key, (NSString*)[params objectForKey:key]];
            first = false;
        }
        else {
            post = [NSString stringWithFormat:@"%@&%@=%@", post, (NSString*)key, (NSString*)[params objectForKey:key]];
        }
    }
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    return [self SendRequest:request];
}

- (NSDictionary*) Put:(NSString*) resource params:(NSDictionary*)params
{
    return Nil;
}

- (NSDictionary*) Delete:(NSString*) resource params:(NSDictionary*)params
{
    return Nil;
}

@end
