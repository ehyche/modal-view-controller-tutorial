//
//  MPFirstViewController.m
//  ModalPresentation
//
//  Created by Eric Hyche on 11/19/13.
//  Copyright (c) 2013 erichyche. All rights reserved.
//

#import "MPFirstViewController.h"
#import "MPColorTableViewController.h"

@interface MPFirstViewController ()

@end

@implementation MPFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"First";
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)description {
    return [NSString stringWithFormat:@"First [%p]", self];
}

- (IBAction)presentRedButtonTapped:(id)sender {
    MPColorTableViewController* controller = [[MPColorTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    controller.colorIndex = 4; //red
    [self.navigationController pushViewController:controller animated:YES];
}

@end
