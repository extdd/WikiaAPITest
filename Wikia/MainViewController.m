//
//  ViewController.m
//  Wikia
//
//  Created by Krzysztof Ignac on 20.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewModel.h"
#import "DetailViewController.h"
#import "ThumbCell.h"
#import "FavButton.h"
#import "Shared.h"

@implementation MainViewController {
    
    MainViewModel *mainViewModel;

    int colsNum; //number of columns in collection view
    int selectedCharacterIndex;
    BOOL isFavFilter;
    
    CGFloat spacing; //one value for cells spacing, lines spacing & insets
    CGFloat cellWidth; //calculated by screen size, colsNum & spacing
    CGFloat cellHeight; //calculated by screen size, colsNum & spacing
    NSIndexPath *selectedCellIndexPath;
    UILabel *favInfoLabel;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isFavFilter = NO;
    spacing = 8.0f;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self initUI];
    [self updateLayout:self.view.frame.size];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadData:) name:DataLoadCompleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeDetailFav:) name:DetailFavChangeNotification object:nil];

    mainViewModel = [[MainViewModel alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [self updateLayout:size];
    
}

# pragma mark - DATA SOURCE

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSUInteger count = mainViewModel.collectionData.count;
    
    if (count < 1 && isFavFilter) {
        favInfoLabel.hidden = NO;
    } else {
        favInfoLabel.hidden = YES;
    }
    
    return count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ThumbCell *cell = (ThumbCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"thumbCell" forIndexPath:indexPath];
    FavButton *favButton = (FavButton *)cell.favButton;
    
    int characterIndex = [mainViewModel.collectionData[indexPath.item] intValue];
    NSData *thumbData = mainViewModel.characters[characterIndex].thumbData;

    if (thumbData) {
        
        cell.imageView.image = [[UIImage alloc] initWithData:thumbData];
        
    } else {
        
        [mainViewModel loadThumbImageForCharacterIndex:(int)characterIndex complete:^(BOOL success) {
            if (success && cell) {
                cell.imageView.image = [[UIImage alloc] initWithData:mainViewModel.characters[characterIndex].thumbData];
            }
        }];
        
    }
    
    cell.label.text = mainViewModel.characters[characterIndex].title;
    favButton.isFav = mainViewModel.characters[characterIndex].isFav;
    
    return cell;
    
}

# pragma mark - DELEGATE

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ThumbCell *cell = (ThumbCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.imageView.alpha = 0.5f;
    
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ThumbCell *cell = (ThumbCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.imageView.alpha = 1.0f;
    
}

# pragma mark - LAYOUT

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(cellWidth, cellHeight);

}

- (void) updateLayout:(CGSize)size {
    
    BOOL isPortrait = UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]);
    
    if (isPortrait) {
        colsNum = 3;
    } else {
        colsNum = 5;
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    layout.minimumLineSpacing = spacing;
    layout.minimumInteritemSpacing = spacing;
    
    cellWidth = floor((size.width - spacing*(colsNum+1))/colsNum);
    cellHeight = floor(cellWidth * 1.2);
    favInfoLabel.center = CGPointMake(floor(size.width/2), floor(favInfoLabel.frame.size.height/2) + 14);

    [self.collectionView.collectionViewLayout invalidateLayout];
    
}

# pragma mark - SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"showDetails"]){
        
        UICollectionViewCell *cell = (UICollectionViewCell *)sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        int index = [mainViewModel.collectionData[indexPath.item] intValue];
        
        DetailViewController *detailViewController = (DetailViewController *)[segue destinationViewController];

        detailViewController.index = index;
        detailViewController.indexPath = indexPath;
        detailViewController.characterTitle = mainViewModel.characters[index].title;
        detailViewController.abstract = mainViewModel.characters[index].abstract;
        detailViewController.pageURL = mainViewModel.characters[index].pageURL;
        detailViewController.thumbData = mainViewModel.characters[index].thumbData;
        detailViewController.isFav = mainViewModel.characters[index].isFav;
        
        selectedCellIndexPath = indexPath;
        selectedCharacterIndex = index;

    }
    
}

# pragma mark - NOTIFICATIONS

- (void) didLoadData:(NSNotification *)notification {
    
    [self.collectionView reloadData];
    
}

- (void) didChangeDetailFav:(NSNotification *)notification {
    
    BOOL isFav = [(FavButton *)notification.object isFav];
    mainViewModel.characters[selectedCharacterIndex].isFav = isFav;
    
    ThumbCell *cell = (ThumbCell *)[self.collectionView cellForItemAtIndexPath:selectedCellIndexPath];
    FavButton *favButton = (FavButton *)cell.favButton;
    favButton.isFav = isFav;

    if (isFavFilter) {
        [mainViewModel favFilter:YES];
        [self.collectionView reloadData];
    }
  
}

# pragma mark - ACTIONS

- (IBAction)fav:(id)sender { //action for the favButton (star) in cell

    FavButton *favButton = (FavButton *)sender;
    ThumbCell *cell = (ThumbCell *)[[favButton superview] superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    int index = [mainViewModel.collectionData[indexPath.item] intValue];
    
    favButton.isFav = !favButton.isFav;
    mainViewModel.characters[index].isFav = favButton.isFav;
    
    if (isFavFilter) {
        [mainViewModel favFilter:YES];
        [self.collectionView reloadData];
    }
    
}

- (IBAction)favFilter:(id)sender { //action for the favBarButton (star) in navigation bar
    
    isFavFilter = !isFavFilter;
    [mainViewModel favFilter:isFavFilter];
    self.favBarButton.isFav = isFavFilter;
    [self.collectionView reloadData];
    
}

# pragma mark - UI

- (void)initUI {
    
    favInfoLabel = [[UILabel alloc] init];
    favInfoLabel.text = @"No favourites :(";
    favInfoLabel.hidden = true;
    favInfoLabel.textAlignment = NSTextAlignmentCenter;
    [favInfoLabel sizeToFit];

    favInfoLabel.frame = CGRectMake(favInfoLabel.frame.origin.x,
                                    favInfoLabel.frame.origin.y,
                                    ceil(favInfoLabel.frame.size.width),
                                    ceil(favInfoLabel.frame.size.height));
    
    [self.collectionView addSubview:favInfoLabel];
    
}

@end
