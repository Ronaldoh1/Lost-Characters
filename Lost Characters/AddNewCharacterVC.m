//
//  CharacterDetailViewController.m
//  Lost Characters
//
//  Created by Ronald Hernandez on 3/31/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "AddNewCharacterVC.h"


@interface AddNewCharacterVC ()<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *actorNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passengerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *HairColorTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTexField;

@property (weak, nonatomic) IBOutlet UIImageView *actorImage;

@end

@implementation AddNewCharacterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    


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

        [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];

        

    } else {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Save your Character"
//                                                                       message:@"All of the fields are REQUIRED!"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK"
//                                                           style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:okButton];
//
//        [self presentViewController:alert animated:YES completion:nil];


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

    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"actor" ascending:YES];
    request.sortDescriptors = @[sortByName];

    self.lostCharacters = [self.myDB executeFetchRequest:request error:nil];
}


@end
