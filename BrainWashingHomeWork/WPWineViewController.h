//
//  WPWineViewController.h
//  BrainWashingHomeWork
//
//  Created by panda on 05.08.13.
//  Copyright (c) 2013 WiredPanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPWineViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property UISearchBar *searchBar;
@property UISearchDisplayController *searchDC;
@end
