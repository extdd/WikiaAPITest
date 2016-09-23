//
//  Networking.m
//  Wikia
//
//  Created by Krzysztof Ignac on 21.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import "Networking.h"

@implementation Networking {
    
    NSString *requestURL;
    NSString *api;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.host = @"http://gameofthrones.wikia.com/";
        api = @"api/v1/";
        
    }
    return self;
}

- (void)loadDataForAPIParams:(NSString *)params {
    
    requestURL = [NSString stringWithFormat:@"%@%@%@", self.host, api, params];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestURL]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               [[NSNotificationCenter defaultCenter] postNotificationName:JSONLoadCompleteNotification object:json];
       
                           }];
    
}

@end
