//
//  DetailViewController.m
//  Wikia
//
//  Created by Krzysztof Ignac on 20.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.textView setTextContent:self.abstract];
    
    self.favButton.fav = self.isFav;
    self.headerLabel.text = self.characterTitle;
    self.imageView.image = [UIImage imageWithData:self.thumbData];
    self.imageView.layer.borderWidth = 1.0f;
    self.imageView.layer.borderColor = [[UIColor colorWithRed:0.12 green:0.33 blue:0.40 alpha:1.0] CGColor];

}

- (IBAction)fav:(id)sender {
    
    FavButton *favButton = (FavButton *)sender;
    favButton.fav = !favButton.fav;
    self.isFav = favButton.fav;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DetailFavChangeNotification object:favButton];

}


- (IBAction)more:(id)sender {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.pageURL]];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
