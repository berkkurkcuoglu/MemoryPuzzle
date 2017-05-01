//
//  ViewController.h
//  MemoryPuzzle
//
//  Created by berk on 4/20/17.
//  Copyright © 2017 berk_kaan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(strong,nonatomic) IBOutletCollection(UIImageView) NSArray *tiles;
@property(nonatomic) NSMutableArray *images;
@property(nonatomic) NSMutableArray *assignedImages;
@property(nonatomic) NSMutableArray *full;
@property(nonatomic) NSMutableArray *opened;
@end

