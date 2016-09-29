//
//  Character.h
//  Wikia
//
//  Created by Krzysztof Ignac on 20.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Character : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *abstract;
@property (strong, nonatomic) NSString *pageURL;
@property (strong, nonatomic) NSString *thumbURL;
@property (strong, nonatomic) NSData *thumbData;

@property int index;
@property BOOL isFav;

@end
