//
//  MPInfoTableViewController.m
//  ModalPresentation
//
//  Created by Eric Hyche on 11/19/13.
//  Copyright (c) 2013 erichyche. All rights reserved.
//

#import "MPInfoTableViewController.h"
#import "MPNavigationController.h"

@interface MPRowInfo : NSObject

@property(nonatomic,copy)   NSString* rowTitle;
@property(nonatomic,copy)   NSString* rowSubTitle;
@property(nonatomic,assign) NSInteger rowIndentationLevel;

@end

@implementation MPRowInfo


@end

@interface MPSectionInfo : NSObject

@property(nonatomic,copy) NSString* sectionTitle;
@property(nonatomic,copy) NSArray*  rows;

@end

@implementation MPSectionInfo

@end

@interface MPInfoTableViewController ()

@property(nonatomic,strong) NSMutableArray* sections;

@end

@implementation MPInfoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.sections = [NSMutableArray array];
        self.navigationItem.title = @"Info";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateControllersInfo];
    self.tableView.rowHeight = 88.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController != nil) {
        if ([self.navigationController isKindOfClass:[MPNavigationController class]]) {
            MPNavigationController* navController = (MPNavigationController*)self.navigationController;
            if (navController.isPresented) {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                                       target:self
                                                                                                       action:@selector(closeButtonTapped:)];
            }
        }
    }
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MPSectionInfo* sectionInfo = [self.sections objectAtIndex:section];
    return [sectionInfo.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.numberOfLines = 3;
    }

    MPSectionInfo* sectionInfo = [self.sections objectAtIndex:indexPath.section];
    MPRowInfo* rowInfo = [sectionInfo.rows objectAtIndex:indexPath.row];

    cell.textLabel.text = rowInfo.rowTitle;
    cell.detailTextLabel.text = rowInfo.rowSubTitle;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPSectionInfo* sectionInfo = [self.sections objectAtIndex:indexPath.section];
    MPRowInfo* rowInfo = [sectionInfo.rows objectAtIndex:indexPath.row];
    return rowInfo.rowIndentationLevel;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    MPSectionInfo* sectionInfo = [self.sections objectAtIndex:section];
    return sectionInfo.sectionTitle;
}

- (void)updateControllersInfo {
    [self.sections removeAllObjects];

    UIApplication* app = [UIApplication sharedApplication];
    // Get the windows and their view controller tree, one section
    // per window, one row per controller
    NSArray* windows = [app windows];
    UIWindow* window0 = [windows objectAtIndex:0];
    UIViewController* rootViewController = window0.rootViewController;
    UIViewController* viewController = rootViewController;

    while (viewController != nil) {
        MPSectionInfo* sectionInfo = [[MPSectionInfo alloc] init];
        if (viewController == rootViewController) {
            sectionInfo.sectionTitle = [NSString stringWithFormat:@"Root %@", viewController];
        } else {
            sectionInfo.sectionTitle = [NSString stringWithFormat:@"Presented %@", viewController];
        }
        // Create the mutable array of row info
        NSMutableArray* tmp = [NSMutableArray array];
        // Get the root view controller for this window
        [self createInfoForController:viewController withDepth:0 inArray:tmp];
        // Copy the array of MPRowInfo's to the section
        sectionInfo.rows = [NSArray arrayWithArray:tmp];
        // Add the section info
        [self.sections addObject:sectionInfo];
        // Get the presented view controller
        viewController = viewController.presentedViewController;
    }
}

- (void)createInfoForController:(UIViewController*)controller withDepth:(NSInteger)depth inArray:(NSMutableArray*)array {
    // Create the row info for this child
    MPRowInfo* rowInfo = [[MPRowInfo alloc] init];
    rowInfo.rowTitle = [controller description];
    rowInfo.rowSubTitle = [NSString stringWithFormat:@"parent=%@\npresenting=%@\npresented=%@",
                           controller.parentViewController, controller.presentingViewController, controller.presentedViewController];
    rowInfo.rowIndentationLevel = depth;
    // Add the info to the mutable array
    [array addObject:rowInfo];
    // Get the children
    NSArray* children = nil;
    if ([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)controller;
        children = tabBarController.viewControllers;
    } else {
        children = controller.childViewControllers;
    }
    NSInteger childrenDepth = depth + 1;
    if ([children count] > 0) {
        for (UIViewController* child in children) {
            [self createInfoForController:child withDepth:childrenDepth inArray:array];
        }
    }
}

- (void)closeButtonTapped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Info [%p]", self];
}

@end
