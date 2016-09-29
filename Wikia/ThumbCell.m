//
//  MainViewCell.m
//  Wikia
//
//  Created by Krzysztof Ignac on 21.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import "ThumbCell.h"

@implementation ThumbCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
 
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor colorWithRed:0.12 green:0.33 blue:0.40 alpha:1.0] CGColor];

}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    self.label.text = @"";
    self.imageView.image = nil;

}

@end
