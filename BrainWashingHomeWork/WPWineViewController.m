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

@interface WPWineViewController () {

    NSArray *_data;
}

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

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *query = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    NSLog(@"query %@", query);
    
    
    [self fetchResultsWithQuery:query];
    [self.collectionView reloadData];
    return YES;
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
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
	self.searchBar.delegate = self;
    //self.searchBar.searchResultsButtonSelected = YES;
    self.searchBar.showsCancelButton = YES;
    [self.view addSubview:self.searchBar];
	//self.collectionView.tableHeaderView = self.searchBar;
    
	// Create the search display controller
	//self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] ;
	//self.searchDC.searchResultsDataSource = self;
	//self.searchDC.searchResultsDelegate = self;
    
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    //[self.view addSubview:[UISearchBar]];
    
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
                    //_data = products.copy;
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
    //cell.backgroundColor = [UIColor redColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    NSLog(@"product.label2x %@", product.issue.title);
    [imageView setImageWithURL:[NSURL URLWithString:product.label2x]];
    [cell addSubview:imageView];
    return cell;
}

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Products *product = _data[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lol1"];
    cell.textLabel.text = product.title;
    NSLog(@"product %@", product.title);
    return cell;
}*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    NSLog(@"[sectionInfo numberOfObjects] %lu", (unsigned long)[sectionInfo numberOfObjects]);
    
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

@end
