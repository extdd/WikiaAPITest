//
//  Networking.h
//  Wikia
//
//  Created by Krzysztof Ignac on 21.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shared.h"

@interface Networking : NSObject

@property (strong, nonatomic) NSString *host;

- (void)loadDataForAPIParams:(NSString *)params;

@end
