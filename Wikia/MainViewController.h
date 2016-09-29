//
//  ViewController.h
//  Wikia
//
//  Created by Krzysztof Ignac on 20.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavBarButton.h"

@interface MainViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet FavBarButton *favBarButton;

- (IBAction)fav:(id)sender;
- (IBAction)favFilter:(id)sender;

@end
