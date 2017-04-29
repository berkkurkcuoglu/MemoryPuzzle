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
    _images = [[NSMutableArray alloc] init];
    _assignedImages = [[NSMutableArray alloc] init];
    _full = [[NSMutableArray alloc] init];
    [_images addObject:[UIImage imageNamed:@"1.jpg"]];
    [_images addObject:[UIImage imageNamed:@"2.jpg"]];
    [_images addObject:[UIImage imageNamed:@"3.jpg"]];
    [_images addObject:[UIImage imageNamed:@"4.jpg"]];
    [_images addObject:[UIImage imageNamed:@"5.jpg"]];
    [_images addObject:[UIImage imageNamed:@"6.jpg"]];
    [_images addObject:[UIImage imageNamed:@"7.jpg"]];
    [_images addObject:[UIImage imageNamed:@"8.jpg"]];
    
    UIImage *cover = [UIImage imageNamed:@"cover.jpg"];
    for(UIImageView *image in _tiles){
        [image setImage:cover];
        [_assignedImages addObject:cover];
        [_full addObject:[NSNumber numberWithInteger:0]];
    }
    
    for(int i=0;i<8;i++){
        NSMutableArray *empty = [self findEmpty];
        u_int32_t length = (int)[empty count];
        u_int32_t random1 = arc4random_uniform(length);
        u_int32_t random2 = arc4random_uniform(length);
        while(random1 == random2)
            random2 = arc4random_uniform(length);
        NSInteger index1 = [[empty objectAtIndex:random1] integerValue];
        NSInteger index2 = [[empty objectAtIndex:random2] integerValue];
        [[_tiles objectAtIndex:index1] setImage:[_images objectAtIndex:i]];
        [[_tiles objectAtIndex:index2] setImage:[_images objectAtIndex:i]];
        [_assignedImages replaceObjectAtIndex:index1 withObject:[_images objectAtIndex:i]];
        [_assignedImages replaceObjectAtIndex:index2 withObject:[_images objectAtIndex:i]];
        [_full replaceObjectAtIndex:index1 withObject:[NSNumber numberWithInteger:1]];
        [_full replaceObjectAtIndex:index2 withObject:[NSNumber numberWithInteger:1]];
    }
    
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

-(NSMutableArray*) findEmpty{
    NSMutableArray *empty = [[NSMutableArray alloc] init];
    NSInteger fullValue;
    for(int i=0;i < 16; i++){
        fullValue = [[_full objectAtIndex:i] integerValue];
        if(fullValue == 0)
            [empty addObject:[NSNumber numberWithInteger:i]];
    }
    return empty;
}
@end
