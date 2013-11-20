//
//  MPColorTableViewController.m
//  ModalPresentation
//
//  Created by Eric Hyche on 11/19/13.
//  Copyright (c) 2013 erichyche. All rights reserved.
//

#import "MPColorTableViewController.h"
#import "MPInfoTableViewController.h"
#import "MPNavigationController.h"

static NSArray* gColors = nil;
static NSArray* gColorNames = nil;

@interface MPColorTableViewController ()

@end

@implementation MPColorTableViewController

+ (void)initialize {
    if (self == [MPColorTableViewController class]) {
        gColors = @[[UIColor darkGrayColor],
                    [UIColor lightGrayColor],
                    [UIColor grayColor],
                    [UIColor redColor],
                    [UIColor greenColor],
                    [UIColor blueColor],
                    [UIColor cyanColor],
                    [UIColor yellowColor],
                    [UIColor magentaColor],
                    [UIColor orangeColor],
                    [UIColor purpleColor],
                    [UIColor brownColor]];
        gColorNames = @[@"Dark Gray",
                        @"Light Gray",
                        @"Gray",
                        @"Red",
                        @"Green",
                        @"Blue",
                        @"Cyan",
                        @"Yellow",
                        @"Magenta",
                        @"Orange",
                        @"Purple",
                        @"Brown"];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = [gColorNames objectAtIndex:self.colorIndex];
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
    self.navigationController.navigationBar.barTintColor = [gColors objectAtIndex:self.colorIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger ret = 0;

    if (section == 0) {
        ret = 1;
    } else {
        ret = [gColors count];
    }

    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSString* text      = nil;
    UIColor*  textColor = nil;
    if (indexPath.section == 0) {
        textColor = [UIColor blackColor];
        if (indexPath.row == 0) {
            text = @"Display Hierarchy Info";
        }
    } else {
        text = [gColorNames objectAtIndex:indexPath.row];
        textColor = [gColors objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = text;
    cell.textLabel.textColor = textColor;

    if (indexPath.section == 0 || indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* ret = nil;

    if (section == 0) {
        ret = @"View Controller Info";
    } else if (section == 1) {
        ret = @"Push a new controller";
    } else {
        ret = @"Present a new controller";
    }

    return ret;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        MPInfoTableViewController* controller = [[MPInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section == 1) {
        // We are pushing a new controller
        MPColorTableViewController* newController = [[MPColorTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        newController.colorIndex = indexPath.row;
        [self.navigationController pushViewController:newController animated:YES];
    } else if (indexPath.section == 2) {
        // We are presenting a new controller
        MPColorTableViewController* newController = [[MPColorTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        newController.colorIndex = indexPath.row;
        // Wrap this in a navigation controller
        MPNavigationController* newNavController = [[MPNavigationController alloc] initWithRootViewController:newController];
        // Now present the nav controller
        [self presentViewController:newNavController animated:YES completion:nil];
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ [%p]", [gColorNames objectAtIndex:self.colorIndex], self];
}

- (void)closeButtonTapped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
