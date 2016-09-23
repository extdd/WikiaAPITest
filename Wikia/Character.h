//
//  Character.h
//  Wikia
//
//  Created by Krzysztof Ignac on 20.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Character : NSObject

@property NSString *uniqueId;
@property NSString *title;
@property NSString *abstract;
@property NSString *pageURL;
@property NSString *thumbURL;
@property NSData *thumbData;

@property int index;
@property BOOL isFav;

@end
