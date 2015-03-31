//
//  ViewController.m
//  Lost Characters
//
//  Created by Ronald Hernandez on 3/31/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "CharacterListViewController.h"

@interface CharacterListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CharacterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}


#pragma mark - Table View Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 0;
}

@end
