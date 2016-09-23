//
//  ViewController.m
//  Wikia
//
//  Created by Krzysztof Ignac on 20.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController {
    
    MainViewModel *mainViewModel;
    
    CGFloat cols;
    CGFloat padding;
    CGFloat cellWidth;
    CGFloat cellHeight;
    UILabel *favInfoLabel;
    NSIndexPath *activeIndexPath;
    int activeCharacterIndex;
    BOOL isFavFilter;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isFavFilter = NO;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self initUI];
    [self updateLayout:self.view.frame.size];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDataLoad:) name:DataLoadCompleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDetailFavChange:) name:DetailFavChangeNotification object:nil];

    mainViewModel = [[MainViewModel alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [self updateLayout:size];
    
}

# pragma mark -
# pragma mark DATA SOURCE

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSUInteger count = mainViewModel.collectionData.count;
    
    if (count < 1 && isFavFilter){
        favInfoLabel.hidden = NO;
    } else {
        favInfoLabel.hidden = YES;
    }
    
    return count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ThumbCell *cell = (ThumbCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"thumbCell" forIndexPath:indexPath];
    
    int characterIndex = [mainViewModel.collectionData[indexPath.item] intValue];
    NSData *thumbData = mainViewModel.characters[characterIndex].thumbData;

    if (thumbData){
        
        cell.imageView.image = [[UIImage alloc] initWithData:thumbData];
        
    } else {
        
        [mainViewModel loadThumbImageForCharacterIndex:(int)characterIndex complete:^(BOOL success) {
            if (success){

                if (cell){
                    cell.imageView.image = [[UIImage alloc] initWithData:mainViewModel.characters[characterIndex].thumbData];
                }
            }
        }];
        
    }
    
    cell.label.text = mainViewModel.characters[characterIndex].title;
    [(FavButton *)cell.favButton setFav:mainViewModel.characters[characterIndex].isFav];
    
    return cell;
    
}

# pragma mark -
# pragma mark DELEGATE

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ThumbCell *cell = (ThumbCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.imageView.alpha = 0.5;
    
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ThumbCell *cell = (ThumbCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.imageView.alpha = 1;
    
}

# pragma mark -
# pragma mark LAYOUT

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(cellWidth, cellHeight);

}

- (void) updateLayout:(CGSize)size {
    
    BOOL isPortrait = UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]);
    
    CGFloat paddingTop;
    
    if (isPortrait) {
        cols = 3;
        paddingTop = 64;
    } else {
        cols = 5;
        paddingTop = 32;
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionViewLayout;
    
    padding = layout.sectionInset.left;
    cellWidth = floor((size.width - padding*(cols+1))/cols);
    cellHeight = floor(cellWidth * 1.2);
    
    CGFloat favInfoLabelW = 300;
    CGFloat favInfoLabelH = 50;
    
    favInfoLabel.frame = CGRectMake(size.width/2 - favInfoLabelW/2, paddingTop, favInfoLabelW, favInfoLabelH);
    favInfoLabel.textAlignment = NSTextAlignmentCenter;

    [self.collectionView.collectionViewLayout invalidateLayout];
    
}

# pragma mark -
# pragma mark SEGUE

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
        
        activeIndexPath = indexPath;
        activeCharacterIndex = index;

    }
    
}

# pragma mark -
# pragma mark NOTIFICATIONS

- (void) didDataLoad:(NSNotification *)notification {
    
    [self.collectionView reloadData];
    
}

- (void) didDetailFavChange:(NSNotification *)notification {
    
    BOOL isFav = [(FavButton *)notification.object fav];
    mainViewModel.characters[activeCharacterIndex].isFav = isFav;
    
    ThumbCell *cell = (ThumbCell *)[self.collectionView cellForItemAtIndexPath:activeIndexPath];
    FavButton *cellFavButton = (FavButton *) cell.favButton;
    cellFavButton.fav = isFav;

    if (isFavFilter){
        [mainViewModel favFilter:YES];
        [self.collectionView reloadData];
    }
  
}

# pragma mark -
# pragma mark ACTIONS

- (IBAction)fav:(id)sender {
    
    FavButton *favButton = (FavButton *)sender;
    ThumbCell *cell = (ThumbCell *)[[favButton superview] superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    int index = [mainViewModel.collectionData[indexPath.item] intValue];
    
    favButton.fav = !favButton.fav;
    mainViewModel.characters[index].isFav = favButton.fav;
    
    if (isFavFilter){
        [mainViewModel favFilter:YES];
        [self.collectionView reloadData];
    }
    
}

# pragma mark -
# pragma mark UI

- (IBAction)favFilter:(id)sender {
    
    isFavFilter = !isFavFilter;
    [mainViewModel favFilter:isFavFilter];

    if (isFavFilter){
        self.favBarButton.image = [UIImage imageNamed:@"favBarOn"];
    } else {
        self.favBarButton.image = [UIImage imageNamed:@"favBarOff"];
    }
    
    [self.collectionView reloadData];
    
}

- (void)initUI {
    
    favInfoLabel = [[UILabel alloc] init];
    favInfoLabel.text = @"No favourites :(";
    favInfoLabel.hidden = true;
    [self.view addSubview:favInfoLabel];
    
}

@end
