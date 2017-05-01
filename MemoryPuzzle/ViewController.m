//
//  ViewController.m
//  MemoryPuzzle
//
//  Created by berk on 4/20/17.
//  Copyright © 2017 berk_kaan. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioServices.h>


@interface ViewController ()
{
    UILabel *progress;
    NSTimer *timer;
    int currMinute;
    int currSeconds;
    int matches;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _images = [[NSMutableArray alloc] init];
    _assignedImages = [[NSMutableArray alloc] init];
    _full = [[NSMutableArray alloc] init];
    _opened = [[NSMutableArray alloc] init];
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        for(UIImageView *image in _tiles){
            [image setImage:cover];
        }
        [self start];
    });
    
    int x = [self view].frame.size.width/2 - 50;
    int y = [self view].frame.size.height/10 - 25;
    progress=[[UILabel alloc] initWithFrame:CGRectMake(x, y, 100, 50)];
    progress.textColor=[UIColor blackColor];
    progress.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
    [progress setText:@"Time : 1:00"];
    progress.backgroundColor=[UIColor clearColor];
    [self.view addSubview:progress];
    currMinute=1;
    currSeconds=0;
    matches = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}
-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [progress setText:[NSString stringWithFormat:@"%@%d%@%02d",@"Time : ",currMinute,@":",currSeconds]];
    }
    else
    {
        [timer invalidate];
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"YOU LOSE!!!"
                                      message:@"Better Luck Next Time!!!"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self performSegueWithIdentifier:@"menuSegue" sender:nil];
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)tapped:(id)sender {
    CGPoint tapPoint = [sender locationInView:self.view];
    int indexNum = [self locateTap:tapPoint];
    NSLog(@"%d",indexNum);
    if(indexNum != -1){
        [[_tiles objectAtIndex:indexNum] setImage:[_assignedImages objectAtIndex:indexNum]];
        if([_opened count] > 0){
           if([[_opened objectAtIndex:0] integerValue] != indexNum)
            [_opened addObject:[NSNumber numberWithInteger:indexNum]];
        }
        else{
           [_opened addObject:[NSNumber numberWithInteger:indexNum]];
        }
        if([_opened count] > 1)
            [self performSelector:@selector(checkMatch) withObject:nil afterDelay:0.75];
    }
    
}

-(int) locateTap:(CGPoint) tapPoint{
    for(UIImageView *image in _tiles){
        if(CGRectContainsPoint(image.frame, tapPoint))
            return (int)[_tiles indexOfObject:image];
    }
    return -1;
}

-(void)checkMatch{
    NSInteger index1 = [[_opened objectAtIndex:0] integerValue];
    NSInteger index2 = [[_opened objectAtIndex:1] integerValue];
    if([_assignedImages objectAtIndex:index1] == [_assignedImages objectAtIndex:index2]){
        [[_tiles objectAtIndex:index1] removeFromSuperview];
        [[_tiles objectAtIndex:index2] removeFromSuperview];
        matches += 1;
        NSString *path  = [[NSBundle mainBundle] pathForResource:@"confirm" ofType:@"wav"];
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        SystemSoundID audioEffect;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
        if(matches > 7){
            [timer invalidate];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"YOU WIN!!!"
                                          message:@"Congratulations!!!"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self performSegueWithIdentifier:@"menuSegue" sender:nil];
                                 }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else{
        UIImage *cover = [UIImage imageNamed:@"cover.jpg"];
        [[_tiles objectAtIndex:index1] setImage:cover];
        [[_tiles objectAtIndex:index2] setImage:cover];
        NSString *path  = [[NSBundle mainBundle] pathForResource:@"cancel" ofType:@"wav"];
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        SystemSoundID audioEffect;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
    [_opened removeAllObjects];
    _opened = [[NSMutableArray alloc] init];
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
