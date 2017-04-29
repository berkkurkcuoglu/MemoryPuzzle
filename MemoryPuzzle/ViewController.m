//
//  ViewController.m
//  MemoryPuzzle
//
//  Created by berk on 4/20/17.
//  Copyright © 2017 berk_kaan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapped:(id)sender {
    CGPoint tapPoint = [sender locationInView:self.view];
    NSLog(@"%d",[self locateTap:tapPoint]);
}

-(int) locateTap:(CGPoint) tapPoint{
    for(UIImageView *image in _tiles){
        if(CGRectContainsPoint(image.frame, tapPoint))
            return (int)[_tiles indexOfObject:image];
    }
    return -1;
}
@end
