//
//  MainViewModel.h
//  Wikia
//
//  Created by Krzysztof Ignac on 20.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Networking.h"
#import "Character.h"
#import "Shared.h"

@interface MainViewModel : NSObject

@property (strong, nonatomic) NSMutableArray<NSString *> *collectionData;
@property (strong, nonatomic) NSMutableArray<Character *> *characters;

@property (strong, nonatomic) NSMutableArray *allIndexes;
@property (strong, nonatomic) NSMutableArray *favIndexes;

- (void)favFilter:(BOOL)isFav;
- (void)loadThumbImageForCharacterIndex:(int)characterIndex complete:(void (^)(BOOL success)) complete;

@end
