//
//  ViewController.h
//  Wikia
//
//  Created by Krzysztof Ignac on 20.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewModel.h"
#import "DetailViewController.h"
#import "ThumbCell.h"
#import "FavButton.h"
#import "Shared.h"

@interface MainViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *favBarButton;

- (IBAction)fav:(id)sender;
- (IBAction)favFilter:(id)sender;

@end

