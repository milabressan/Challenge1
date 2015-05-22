//
//  GlanceController.m
//  Pet's Bay WatchKit Extension
//
//  Created by Jonathan Andrade on 21/05/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import "GlanceController.h"
//#import <Parse/Parse.h>


@interface GlanceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *animalNameLabel;

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self.animalNameLabel setText:@"Caralho"];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end


