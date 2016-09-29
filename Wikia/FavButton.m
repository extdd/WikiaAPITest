//
//  FavButton.m
//  Wikia
//
//  Created by Krzysztof Ignac on 22.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import "FavButton.h"

@implementation FavButton {
    
    BOOL _isFav;
    
}

- (BOOL)isFav {
    
    return _isFav;
    
}

- (void)setIsFav:(BOOL)fav {
    
    _isFav = fav;
    
    if (fav) {
        [self setImage:[UIImage imageNamed:@"favOn"] forState:UIControlStateNormal];
    } else {
        [self setImage:[UIImage imageNamed:@"favOff"] forState:UIControlStateNormal];
    }
    
}

@end
