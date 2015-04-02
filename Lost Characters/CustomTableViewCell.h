//
//  CustomTableViewCell.h
//  Lost Characters
//
//  Created by Ronald Hernandez on 4/1/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *passengerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *HairColorLabel;

@property (weak, nonatomic) IBOutlet UILabel *actorName;


@end
