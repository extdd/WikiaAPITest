//
//  MainViewModel.m
//  Wikia
//
//  Created by Krzysztof Ignac on 20.09.2016.
//  Copyright © 2016 EXTENDED. All rights reserved.
//

#import "MainViewModel.h"
#import "Networking.h"
#import "Shared.h"

@implementation MainViewModel {
    
    Networking *networking;
    
    NSString *apiParams;
    NSString *category;
    
    int limit; //number of results
    
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        networking = [[Networking alloc] init];
        category = @"Characters";
        limit = 75;
        apiParams = [NSString stringWithFormat:@"Articles/Top?expand=1&category=%@&limit=%@&abstract=500", category, [NSString stringWithFormat:@"%i", limit]];

        [self initData];
        
    }
    
    return self;
    
}

# pragma mark - DATA

- (void)initData {
    
    self.characters = [[NSMutableArray alloc] init];
    self.collectionData = [[NSMutableArray alloc] init];
    self.allIndexes = [[NSMutableArray alloc] init];
    self.favIndexes = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadJSON:) name:JSONLoadCompleteNotification object:nil];
    [networking loadDataForAPIParams:apiParams];
    
}

- (void)didLoadJSON:(NSNotification *)notification {
    
    NSDictionary *json = (NSDictionary *)notification.object;
    NSArray *items = (NSArray *) [json objectForKey:@"items"];
    NSDictionary *item;
    
    int index = 0;
    
    for (item in items) {
        [self initCharacter:item withIndex:index];
        [self.allIndexes addObject:[NSNumber numberWithInt:index]];
        index++;
    }
    
    self.collectionData = self.allIndexes;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JSONLoadCompleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:DataLoadCompleteNotification object:nil];
    
}

- (void) initCharacter:(NSDictionary *)data withIndex:(int)index {
    
    Character *character = [[Character alloc] init];
    character.index = index;
    character.title = [data valueForKey:@"title"];
    character.abstract = [data valueForKey:@"abstract"];
    character.thumbURL = [data valueForKey:@"thumbnail"];
    character.pageURL = [NSString stringWithFormat:@"%@%@", networking.host, [data valueForKey:@"url"]];

    [self.characters addObject:character];
    
}

# pragma mark - FAV FILTER

- (void)favFilter:(BOOL)isFav {
    
    if (isFav) {
        
        Character *character;
        self.favIndexes = [[NSMutableArray alloc] init];
        
        for (character in self.characters) {
            if (character.isFav){
                [self.favIndexes addObject:[NSNumber numberWithInt:character.index]];
            }
        }
        
        self.collectionData = self.favIndexes;
        
    } else {
        
        self.collectionData = self.allIndexes;
        
    }
    
}

# pragma mark - THUMB IMAGE LOADING

- (void)loadThumbImageForCharacterIndex:(int)characterIndex complete:(void (^)(BOOL success))complete {
 
    Character *character = self.characters[characterIndex];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:character.thumbURL]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error){
                                   character.thumbData = data;
                                   complete(YES);
                               } else{
                                   complete(NO);
                               }
                           }];
 
}

@end
