//
//  SimpleREST.h
//  SimpleREST
//
//  Created by Jeff Lutzenberger on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleREST : NSObject

@property (nonatomic) NSString* url;
@property (nonatomic) BOOL logSuccess;
@property (nonatomic) BOOL logErrors;

- (id)init:(NSString*)urlStr;

- (NSDictionary*) Get:(NSString*) resource params:(NSDictionary*)params;
- (NSDictionary*) Post:(NSString*) resource params:(NSDictionary*)params;
- (NSDictionary*) Put:(NSString*) resource params:(NSDictionary*)params;
- (NSDictionary*) Delete:(NSString*) resource params:(NSDictionary*)params;
@end
