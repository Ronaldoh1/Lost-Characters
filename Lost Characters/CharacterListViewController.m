//
//  ViewController.m
//  Lost Characters
//
//  Created by Ronald Hernandez on 3/31/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "CharacterListViewController.h"
#import "AppDelegate.h"

@interface CharacterListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *myDB;
@property NSDictionary *dictionaryArray;
@property NSArray* lostCharacters;

@end

@implementation CharacterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dictionaryArray = [[NSDictionary alloc]init]; //initialize the dictionary.

    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate]; //initialize the appDelegate

    self.myDB = appDelegate.managedObjectContext;


    NSString *path = [[NSBundle mainBundle] pathForResource:@"lost" ofType:@"plist"]; //get the path for the plist.

    NSArray *contentArray = [NSArray arrayWithContentsOfFile:path]; //get the content from plist.


    NSMutableArray *pListDataArray = [[NSMutableArray alloc]initWithArray:contentArray copyItems:YES]; //pListData Array.




    for (NSDictionary *dict in pListDataArray) {

        [self savePListDataToDataBase:dict];

    }

}

-(void)savePListDataToDataBase:(NSDictionary *)dataDictionary{

    NSManagedObject *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:self.myDB];
    NSString *characterName = dataDictionary[@"actor"];

    [character setValue:characterName forKey:@"actorName"];

    NSString *passengerName = dataDictionary[@"passenger"];
    [character setValue:passengerName forKey:@"passengerName"];

    [self.myDB save:nil];
    [self load];

}
-(void)load{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];
    self.lostCharacters = [self.myDB executeFetchRequest:request error:nil];
    [self.tableView reloadData];

}


#pragma mark - Table View Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
   // NSDictionary *dictionaryArray = [self.tableArray objectAtIndex:indexPath.row];
   // NSArray *keyArrays = dictionaryArray.allKeys;

    NSManagedObject *character =[self.lostCharacters objectAtIndex:indexPath.row];


    cell.textLabel.text = [character valueForKey:@"actorName"];

    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    //NSDictionary *dictionary = [self.tableArray objectAtIndex:section];

    return self.lostCharacters.count;
}

@end
