//
//  ViewController.m
//  Lost Characters
//
//  Created by Ronald Hernandez on 3/31/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "CharacterListViewController.h"
#import "AppDelegate.h"
#import "AddNewCharacterVC.h"

@interface CharacterListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *myDB;
@property NSDictionary *dictionaryArray;
@property NSArray* lostCharacters;
@property NSIndexPath* indexForItemToDelete;

@end

@implementation CharacterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dictionaryArray = [[NSDictionary alloc]init]; //initialize the dictionary.

    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate]; //initialize the appDelegate

    self.myDB = appDelegate.managedObjectContext;

    //need to load the data from the array before saving..if we don't do this step, then the lostcharacters array will alway have a count of 0..therefore save data from plist will always get called. 
    [self load];


    if (self.lostCharacters.count == 0) {
        [self savePListDataToDataBase];
        [self load];
    }
      NSLog(@"%lu", (unsigned long)self.lostCharacters.count);

}

-(void)savePListDataToDataBase{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"lost" ofType:@"plist"]; //get the path for the plist.

    NSArray *contentArray = [NSArray arrayWithContentsOfFile:path]; //get the content from plist.


    NSMutableArray *pListDataArray = [[NSMutableArray alloc]initWithArray:contentArray copyItems:YES]; //pListData Array.

    for (NSDictionary *dataDictionary in pListDataArray) {



    NSManagedObject *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:self.myDB];
    NSString *characterName = dataDictionary[@"actor"];

    [character setValue:characterName forKey:@"actorName"];

    NSString *passengerName = dataDictionary[@"passenger"];

    [character setValue:passengerName forKey:@"passengerName"];
    }

    [self.myDB save:nil];

    [self load];

}


-(void)load
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];

    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"actorName" ascending:YES];
    request.sortDescriptors = @[sortByName];

    self.lostCharacters = [self.myDB executeFetchRequest:request error:nil];
      [self.tableView reloadData];
}-(void) displayAlert{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete City?" message:@"Are you should want to delete selected item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];


    [alert show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    //button index 0 means the user presses the cancel button.
    if (buttonIndex == 0) {


    }else{
        //else this means that the user click on delete and should continue to remove the item from

//[self.lostCharacters removeObserver:<#(NSObject *)#> forKeyPath:self.indexForItemToDelete context:nil];
        [self.tableView reloadData]; // tell table to refresh now
        
        
        
        
    }
}



#pragma mark - Table View Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    //change the color of the cell so that every other cell is clear.
    if (indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor clearColor]];
    }

   // NSDictionary *dictionaryArray = [self.tableArray objectAtIndex:indexPath.row];
   // NSArray *keyArrays = dictionaryArray.allKeys;

    NSManagedObject *character =[self.lostCharacters objectAtIndex:indexPath.row];


    cell.textLabel.text = [character valueForKey:@"actorName"];
    cell.detailTextLabel.text =@"passenger: %@, age:%@, hair color:%@ gender:%@", [character valueForKey:@"passengerName"];



    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this

       self.indexForItemToDelete = indexPath;

        [self displayAlert];
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    //NSDictionary *dictionary = [self.tableArray objectAtIndex:section];

    return self.lostCharacters.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"SMOKE MONSTER";
}

- (IBAction)onEditButtonPressed:(UIBarButtonItem *)editButton
{
    if ([editButton.title isEqualToString:@"Edit"])
    {
        [self.tableView setEditing:YES animated:YES];
        editButton.title = @"Done";
    }
    else
    {
        [self.tableView setEditing:NO animated:YES];
        editButton.title = @"Edit";
    }

}

//Need a prepared for segue to give access to myDB to the addCharacter View Controller.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AddNewCharacterVC *DestVC = segue.destinationViewController;
    DestVC.myDB = self.myDB;
    DestVC.lostCharacters = self.lostCharacters;

}


@end
