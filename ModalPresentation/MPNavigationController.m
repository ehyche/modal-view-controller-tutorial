//
//  MPNavigationController.m
//  ModalPresentation
//
//  Created by Eric Hyche on 11/19/13.
//  Copyright (c) 2013 erichyche. All rights reserved.
//

#import "MPNavigationController.h"

@interface MPNavigationController ()

@property(nonatomic,readwrite) BOOL isPresented;

@end

@implementation MPNavigationController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isPresented = [self isBeingPresented];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Navigation [%p]", self];
}

@end
