//
//  ViewController.m
//  Lost Characters
//
//  Created by Ronald Hernandez on 3/31/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "CharacterListViewController.h"
#import "AppDelegate.h"
#import "AddOrEditCharacterVC.h"
#import "CustomTableViewCell.h"

@interface CharacterListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *myDB;
@property NSDictionary *dictionaryArray;
@property NSArray* lostCharacters;
@property NSIndexPath* indexForItemToDelete;
@property BOOL isEditMode;
@property NSIndexPath *selectedIndexPath;
@property NSMutableArray *mutableLostCharactersArray;
@end

@implementation CharacterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //initialize the dictionary.
    self.dictionaryArray = [[NSDictionary alloc]init];

    //create a mutable array to load the table.
    self.mutableLostCharactersArray = [NSMutableArray new];

    //initialize the appDelegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.myDB = appDelegate.managedObjectContext;

    //need to load the data from the array before saving..if we don't do this step, then the lostcharacters array will alway have a count of 0..therefore save data from plist will always get called.
    [self load];

    //use user defualts to check it it has been run. It will save
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"hasBeenRun"] == nil){
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        [defaults setObject:@01 forKey:@"hasBeenRun"];
        [defaults synchronize];
        [self savePListDataToDataBase];
        [self load];

    }

}
//When the user returns to the Character List, we want to call the load method to get the data from core data but we also want to reload the table with the new data.
-(void)viewWillAppear:(BOOL)animated{

    [self load];
    [self.tableView reloadData];
}

//herlper method to load the data from Plist to DB.
-(void)savePListDataToDataBase{
    //get the path for the plist.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lost" ofType:@"plist"];
    //get the content from plist.
    NSArray *contentArray = [NSArray arrayWithContentsOfFile:path];
    //pListData Array.
    NSMutableArray *pListDataArray = [[NSMutableArray alloc]initWithArray:contentArray copyItems:YES];

    //Loop through pListData array and obtain the data dictionaries and extract the data from each individual dictionary.
    for (NSDictionary *dataDictionary in pListDataArray) {

        NSManagedObject *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:self.myDB];
        NSString *characterName = dataDictionary[@"actor"];

        [character setValue:characterName forKey:@"actorName"];

        NSString *passengerName = dataDictionary[@"passenger"];

        [character setValue:passengerName forKey:@"passengerName"];
    }
    //need to save data to the db.
    [self.myDB save:nil];
    //need to reload the data.
    [self load];

}

//Load does a fetch request to the db, extracts data and sorts data and finally stores it in our lost character array.
-(void)load
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];

    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"actorName" ascending:YES];
    request.sortDescriptors = @[sortByName];

    self.lostCharacters = [self.myDB executeFetchRequest:request error:nil];

    self.mutableLostCharactersArray = self.lostCharacters.mutableCopy;

    [self.tableView reloadData];
}

-(void) displayAlert{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete City?" message:@"Are you should want to delete selected item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];

    [alert show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    //button index 0 means the user presses the cancel button.
    if (buttonIndex == 0) {


    }else{
        //else this means that the user click on delete and should continue to remove the item from

        [self.mutableLostCharactersArray removeObjectAtIndex:self.indexForItemToDelete.row];
        [self.tableView reloadData]; // tell table to refresh now


    }
}



#pragma mark - Table View Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{



    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    //change the color of the cell so that every other cell is clear.
    if (indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor clearColor]];
    }

    // NSDictionary *dictionaryArray = [self.tableArray objectAtIndex:indexPath.row];
    // NSArray *keyArrays = dictionaryArray.allKeys;

    NSManagedObject *character = [self.mutableLostCharactersArray objectAtIndex:indexPath.row];




    //convert NSDAta to and actual image to display.
    UIImage *image = [UIImage imageWithData:[character valueForKey:@"actorPhoto"]];
    cell.imageView.image = image;
    cell.actorName.text =  [character valueForKey:@"actorName"];
    cell.passengerNameLabel.text = [character valueForKey:@"passengerName"];
    cell.ageLabel.text = [character valueForKey:@"actorAge"];
    cell.HairColorLabel.text = [character valueForKey:@"actorHairColor"];
    cell.genderLabel.text = [character valueForKey:@"actorGender"];



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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndexPath = indexPath;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    //NSDictionary *dictionary = [self.tableArray objectAtIndex:section];

    return self.mutableLostCharactersArray.count;
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
    AddOrEditCharacterVC *DestVC = segue.destinationViewController;
    DestVC.myDB = self.myDB;
    DestVC.lostCharacters = self.mutableLostCharactersArray.mutableCopy;
    if ([segue.identifier isEqualToString:@"editCharacter"]) {
        self.isEditMode = true;
        DestVC.isEditMode = self.isEditMode;
        DestVC.indexPath = self.selectedIndexPath;
    }
    
}


@end
