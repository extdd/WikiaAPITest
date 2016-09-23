//
//  DetailTextView.m
//  Wikia
//
//  Created by Krzysztof Ignac on 22.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import "ExpandedTextView.h"

@implementation ExpandedTextView {

    BOOL isExpanded;
    
    NSString *textShort;
    NSString *textLong;
    UILongPressGestureRecognizer *longPressRecognizer;
    
}

- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
        [self initLongPress];
    }
    
    return self;
    
}

- (void) initLongPress {
    
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]){
            recognizer.enabled = NO;
        }
    }
    
    longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress)];
    [self addGestureRecognizer:longPressRecognizer];
    
}

- (void) didLongPress {
    
    if (longPressRecognizer.state == UIControlEventTouchDown){
        [self expandText:!isExpanded];
    }
    
}

- (void) setTextContent:(NSString *)textContent {
    
    textLong = textContent;
    textShort = [self getShortString:textContent];
    isExpanded = NO;
    self.text = textShort;
    
}

- (void)expandText:(BOOL)expand {
    
    if (expand && textLong){
        self.text = textLong;
        isExpanded = YES;
    } else {
        self.text = textShort;
        isExpanded = NO;
    }
    
}

- (NSString*)getShortString:(NSString *)longString {
    
    NSInteger shortMaxLen = 100;
    NSString *shortString;
    
    if (longString.length > shortMaxLen){
        shortString = [longString substringToIndex: shortMaxLen];
        NSRange space = [shortString rangeOfString:@" " options:NSBackwardsSearch];
        shortString = [shortString substringToIndex:space.location];
        shortString = [NSString stringWithFormat:@"%@%@", shortString, @"..."];
    } else {
        shortString = longString;
    }
    
    return shortString;
    
}


@end
