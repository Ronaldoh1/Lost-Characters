//
//  CharacterDetailViewController.m
//  Lost Characters
//
//  Created by Ronald Hernandez on 3/31/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "AddOrEditCharacterVC.h"


@interface AddOrEditCharacterVC ()<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *actorNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passengerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *HairColorTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTexField;
@property (weak, nonatomic) IBOutlet UIImageView *actorImage;
@property (weak, nonatomic) IBOutlet UIButton *editOrAddbutton;

@end

@implementation AddOrEditCharacterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpEditOrAddMode];

    //need to load the data from the array before saving..if we don't do this step, then the lostcharacters array will alway have a count of 0..therefore save data from plist will always get called.
    [self load];


}

//This method helps to toggle between edit or add mode. It alls depends on the boolean value received from the source view controller.
-(void)setUpEditOrAddMode{

    if (self.isEditMode == true) {

        [self.editOrAddbutton setTitle:@"Edit Info" forState:UIControlStateNormal];
        NSManagedObject *lostCharacter = [self.lostCharacters objectAtIndex:self.indexPath.row];

        self.actorNameTextField.text = [lostCharacter valueForKey:@"actorName"];
        self.passengerNameTextField.text = [lostCharacter valueForKey:@"passengerName"];
        self.HairColorTextField.text = [lostCharacter valueForKey:@"actorHairColor"];
        self.genderTextField.text = [lostCharacter valueForKey:@"actorGender"];
        self.ageTexField.text = [lostCharacter valueForKey:@"actorAge"];

        UIImage *image = [UIImage imageWithData:[lostCharacter valueForKey:@"actorPhoto"]];

        self.actorImage.image = image;
        [self load];

    }

}



#pragma mark - ActionSheet delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 ) {
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerView animated:YES completion:nil];





    }else if( buttonIndex == 1 ) {

        UIImagePickerController *pickerView =[[UIImagePickerController alloc]init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerView animated:YES completion:nil];

    }
}

#pragma mark - PickerDelegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    [self dismissViewControllerAnimated:picker completion:nil];

    UIImage * img = [info valueForKey:UIImagePickerControllerEditedImage];

    self.actorImage.image = img;

}
- (IBAction)addCharacterOnTap:(id)sender {


    if (![self.actorNameTextField.text isEqualToString:@""] && ![self.passengerNameTextField.text isEqualToString:@""] && ![self.HairColorTextField.text isEqualToString:@""] && ![self.genderTextField.text isEqualToString:@""] &&![self.ageTexField.text isEqualToString:@""]) {

        NSManagedObject *lostCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"Character"inManagedObjectContext:self.myDB];
        [lostCharacter setValue:self.actorNameTextField.text forKey:@"actorName"];
        [lostCharacter setValue:self.passengerNameTextField.text forKey:@"passengerName"];
        [lostCharacter setValue:self.genderTextField.text forKey:@"actorGender"];
        [lostCharacter setValue:self.actorNameTextField.text forKey:@"actorName"];
        [lostCharacter setValue:self.HairColorTextField.text forKey:@"actorHairColor"];
        [lostCharacter setValue:self.ageTexField.text forKey:@"actorAge"];

        NSData *imageData = UIImagePNGRepresentation(self.actorImage.image);

        [lostCharacter setValue:imageData forKey:@"actorPhoto"];

        [self.myDB save:nil];


        //  [sender resignFirstResponder];

        [self.navigationController popViewControllerAnimated:YES];



    } else {
        NSLog(@"cannot leave items blank");

    }
}
- (IBAction)chooseAnImageButtonTapped:(id)sender {

    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Select for Lost Character" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From library",@"From Camera", nil];

    [action showInView:self.view];

}

//MARK: Load Method for Core Data

-(void)load
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];

    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"actorName" ascending:YES];
    request.sortDescriptors = @[sortByName];
    
    self.lostCharacters = [self.myDB executeFetchRequest:request error:nil];
}


#pragma TextField Slide Up and Down 

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up:(BOOL)up
{
    const int movementDistance = 200; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed

    int movement = (up ? -movementDistance : movementDistance);

    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
