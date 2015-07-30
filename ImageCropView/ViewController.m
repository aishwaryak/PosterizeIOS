//
//  ViewController.m
//  ImageCropView
//
//  Created by Aishwarya Krishnan
//
//

#import "ViewController.h"
#import "UserInputViewController.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize imageCropView;
@synthesize delegate;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    imageCropView.image = [UIImage imageNamed:@"pict.jpeg"];
    imageCropView.controlColor = [UIColor cyanColor];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    NSLog(@"The newly loadde string is %@ %@",_widthString,_heightString);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takeBarButtonClick:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:self];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

- (IBAction)openBarButtonClick:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}



- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    imageView.image = image;
    [_camera setHidden:YES];
    [_posterize setHidden:YES];
    [_gallery setHidden:YES];
    [_insta setHidden:YES];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
//    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self
                                             action:@selector(cancel:)];
    [picker dismissViewControllerAnimated:NO completion:nil];
    
}
- (void)backButtonPressed
{
    [_camera setHidden:NO];
    [_posterize setHidden:NO];
    [_gallery setHidden:NO];
    [_insta setHidden:NO];
    
    imageView.image = nil;

}
- (IBAction)cancel:(id)sender
{
    NSLog(@"Cancel");
    
    /*if ([self.delegate respondsToSelector:@selector(ViewControllerDidCancel:)])
    {
        [self.delegate ViewControllerDidCancel:self];
    }*/
    //[self viewDidLoad];
    [self.view setNeedsDisplay];
    UIStoryboard* _initalStoryboard;
    _initalStoryboard = self.storyboard;
    for (UIView* view in self.view.subviews)
    {
        
        [view removeFromSuperview];
    }
    
    UIViewController* initialScene = [_initalStoryboard instantiateInitialViewController];
    self.view.window.rootViewController = initialScene;
    

}

- (IBAction)cropBarButtonClick:(id)sender {
    
    if(image != nil){
        NSLog(@"Crop!");
        ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:image];
        controller.delegate = self;
        controller.blurredBackground = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)ImageCropViewController:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
   image = croppedImage;
   imageView.image = croppedImage;
    
    //[self cropImage :croppedImage];
    
   [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    imageView.image = image;
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail!"
                                                        message:[NSString stringWithFormat:@"Saved with error %@", error.description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succes!"
                                                                message:@"Saved to camera roll"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];

    }
}

- (IBAction)saveBarButtonClick:(id)sender {
    //TODO - uncomment this
    //if (image != nil){
    //    UIImageWriteToSavedPhotosAlbum(image, self ,  @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
    //}
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@" From view controller The segue identifer %@",segue.identifier);
    
    if([segue.identifier isEqualToString:@"UserInputScreen"])
    {
        NSLog(@"UserInputScreen");
        
        UserInputViewController *controller = (UserInputViewController *)segue.destinationViewController;
        controller.image = image;
        //controller.stringForVC2 = @"some string";
        // here you have passed the value //
        
    }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
     NSLog(@" From view controller should perform segue");
    
    return YES;
    
}

@end
