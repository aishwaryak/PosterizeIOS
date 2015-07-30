//
//  ViewController.m
//  ImageCropView
//
//  Created by Aishwarya Krishnan
//
//

#import "ViewController.h"

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
    
    [self cropImage :croppedImage];
    
   [[self navigationController] popViewControllerAnimated:YES];
}


- (void) cropImage:(UIImage *)croppedImage{
    
    
    NSLog(@"cutting image");
    
    CGSize size = [croppedImage size];
    
    CGFloat pageOffset = 0;
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *pdfFileName = [documentDirectory stringByAppendingPathComponent:@"mypdf.pdf"];
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    int a4Height = 11;
    double a4Width = 8.27;
    
    double oldWidth = size.width,oldHeight = size.height;
    double newWidth=25,newHeight=33; //The size of the poster
    
    
    if(size.height > size.width) {
        newWidth = size.height;
        newHeight = size.width;
    }
    
    int totalA4Width = newWidth/a4Width;
    int totalA4Height = newHeight/a4Height;
    
    
    //imageDivision
    
    double loopWidth = oldWidth / totalA4Width;
    double loopHeight = oldHeight / totalA4Height;
    
    
    double edgeWidth = loopWidth * (totalA4Width - (int) totalA4Width);
    double edgeHeight = loopHeight * (totalA4Height - (int) totalA4Height);
    
    int xStart = 0, yStart = 0, xEnd = (int)(loopWidth), yEnd = (int)(loopHeight);
    bool isPartWidth = false;
    bool isPartHeight = false;
        
        for(int j = 0; j <= (int) totalA4Height; j++)
        {
            for(int i=0; i <= (int) totalA4Width; i++)
            {
                isPartWidth = false;
                isPartHeight = false;
                
                xEnd = (int)(loopWidth);
                yEnd = (int)(loopHeight);
                
                if(i == (int) totalA4Width)
                {
                    isPartWidth = true;
                    xEnd = (int)edgeWidth;
                    //alignment = Image.LEFT;
                }
                if(j == (int) totalA4Height)
                {
                    isPartHeight = true;
                    yEnd = (int)edgeHeight;
                    //alignment = Image.TOP;
                }
                xStart = (int)(i * (int)(loopWidth));
                yStart = (int)(j * (int)(loopHeight));
                
                [self makeRectangle :xStart :yStart :xEnd :yEnd :croppedImage];
                //Todo - write to PDF
                
            }
        }

    
    //imageDivision



    UIGraphicsEndPDFContext();
}



- (void) makeRectangle:(NSInteger) startX: (NSInteger) startY : (NSInteger) width : (NSInteger) height: (UIImage *) cutImage {
    
    UIImageView *cutImageView = [[UIImageView alloc] initWithImage:cutImage];
    CGSize size = [cutImage size];
    
    // Frame location in view to show original image
    [cutImageView setFrame:CGRectMake(0, 0, size.width, size.height)];
    
    // Create rectangle that represents a cropped image
    // from the middle of the existing image
    CGRect rect = CGRectMake(startX,startY ,
                             width, height);
    
    // Create bitmap image from original image data,
    // using rectangle to specify desired crop area
    CGImageRef imageRef = CGImageCreateWithImageInRect([cutImage CGImage], rect);
    
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    // Create and show the new image from bitmap data
    cutImageView = [[UIImageView alloc] initWithImage:img];
    [cutImageView setFrame:CGRectMake(startX,startY,width,height)];
    
    if(cutImageView.image!=nil) {
        NSLog(@"It should be saved");
        //792, 1122ß
       // UIImageWriteToSavedPhotosAlbum(cutImageView.image, self ,  @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
        [cutImageView.image drawInRect:CGRectMake(0, 0, 612,792)];
    }
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
    if (image != nil){
        UIImageWriteToSavedPhotosAlbum(image, self ,  @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
    }
}
@end
