//
//  MPSecondViewController.m
//  ModalPresentation
//
//  Created by Eric Hyche on 11/19/13.
//  Copyright (c) 2013 erichyche. All rights reserved.
//

#import "MPSecondViewController.h"
#import "MPColorTableViewController.h"

@interface MPSecondViewController ()

@end

@implementation MPSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Second";
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Second [%p]", self];
}

- (IBAction)presentBlackButtonTapped:(id)sender {
    MPColorTableViewController* controller = [[MPColorTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    controller.colorIndex = 0; // dark gray
    [self.navigationController pushViewController:controller animated:YES];
}

@end
