//
//  FavBarButton.m
//  Wikia
//
//  Created by Krzysztof Ignac on 26.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import "FavBarButton.h"

@implementation FavBarButton {
    
    BOOL _isFav;

}

- (BOOL)isFav {
    
    return _isFav;
    
}

- (void)setIsFav:(BOOL)fav {
    
    _isFav = fav;
    
    if (fav) {
        self.image = [UIImage imageNamed:@"favBarOn"];
    } else {
        self.image = [UIImage imageNamed:@"favBarOff"];
    }
    
}

@end
