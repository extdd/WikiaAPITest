//
//  DetailViewController.h
//  Wikia
//
//  Created by Krzysztof Ignac on 20.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandedTextView.h"
#import "FavButton.h"
#import "Shared.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet ExpandedTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet FavButton *favButton;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSString *characterTitle;
@property (strong, nonatomic) NSString *abstract;
@property (strong, nonatomic) NSString *pageURL;
@property (strong, nonatomic) NSData *thumbData;

@property int index;
@property BOOL isFav;

- (IBAction)more:(id)sender;
- (IBAction)fav:(id)sender;

@end
