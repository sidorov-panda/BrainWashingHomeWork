//
//  WPWineViewController.m
//  BrainWashingHomeWork
//
//  Created by panda on 05.08.13.
//  Copyright (c) 2013 WiredPanda. All rights reserved.
//

#import "WPWineViewController.h"
#import "WPIssueModel.h"
#import "Products.h"
#import "WPCoreDataManager.h"
#import "UIImageView+AFNetworking.h"

@interface WPWineViewController ()

@end

@implementation WPWineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchText isEqualToString:@""] && searchText) {
        [self fetchResultsWithQuery:searchText];
        [self.collectionView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLayerMask];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
	self.searchBar.delegate = self;

    self.searchBar.showsCancelButton = YES;
    [self.view addSubview:self.searchBar];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [[WPCoreDataManager sharedInstance] loadContextWithCompletionHandler:^(NSError *error) {
        if (!error) {
            [WPIssueModel issuesWithCompletionHandler:^(NSArray *issues, NSError *error) {
                [Products productWithCompletionHandler:^(NSArray *products, NSError *error) {
                    for (Products *product in products) {
                        for (WPIssueModel *issue in issues) {
                            if ([issue.issueId isEqualToNumber:[product issueId]]) {
                                product.issue = issue;
                                [self.collectionView reloadData];
                            }
                        }
                    }
                    [self fetchResultsWithQuery:@""];

                    [self.collectionView reloadData];
                }];
            }];
        } else {
            NSLog(@"the error is here %@", error);
        }
    }];
    
}

- (void)fetchResultsWithQuery:(NSString *)query {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    if (![query isEqualToString:@""]) {
        [request setPredicate:[NSPredicate predicateWithFormat:@"(issue.title CONTAINS[cd] %@) OR (title contains[cd] %@)", query, query]];
    }
    
    // Получаем объект описания записи, который необходим для request
    NSEntityDescription* desc = [NSEntityDescription entityForName:NSStringFromClass([Products class])
                                            inManagedObjectContext:[[WPCoreDataManager sharedInstance] defaultManagedObjectContext]];
    [request setEntity:desc];
    
    // Обязательно устанавливаем порядок сортировки, иначе будет креш
    NSMutableArray *sortDescriptors = @[].mutableCopy;
    //[sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES]];
    [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES]];
    [request setSortDescriptors:sortDescriptors];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:[[WPCoreDataManager sharedInstance] defaultManagedObjectContext]
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
    self.fetchedResultsController.delegate = self;
    NSError *fetchError;
    if (![self.fetchedResultsController performFetch:&fetchError]) {
        NSLog(@"%@", fetchError.localizedDescription);
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Products *product = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    NSLog(@"product: %@ %@", product.title, product.issue.title);
    [imageView setImageWithURL:[NSURL URLWithString:product.label2x]];
    [cell addSubview:imageView];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.fetchedResultsController.sections.count;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupLayerMask {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.locations = @[@0.9, @1];
    gradientLayer.startPoint = CGPointMake(1, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor blackColor] CGColor]
                            , (id)[[UIColor clearColor] CGColor]
                            , nil];
    gradientLayer.opacity = 0.4;
    gradientLayer.frame = self.view.bounds;
    self.view.layer.mask = gradientLayer;
}

@end
