//
//  CharacterDetailViewController.h
//  Lost Characters
//
//  Created by Ronald Hernandez on 3/31/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddOrEditCharacterVC : UIViewController
@property NSManagedObjectContext *myDB;
@property NSMutableArray *lostCharacters;
@property BOOL isEditMode;
@property NSIndexPath *indexPath;


@end
