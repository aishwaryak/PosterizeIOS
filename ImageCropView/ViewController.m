//
//  ViewController.m
//  ImageCropView
//
//  Created by Aishwarya Krishnan
//
//

#import "ViewController.h"
#import "UIImage+FiltrrCompositions.h"

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
    [_crop setHidden:YES];
    [_measure setHidden:YES];
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
//    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(50,50,320,480)];
//    _scrollView.showsVerticalScrollIndicator=YES;
//    _scrollView.scrollEnabled=YES;
//    _scrollView.userInteractionEnabled=YES;
//    [self.view addSubview:_scrollView];
//    _scrollView.contentSize = CGSizeMake(320,960);
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button addTarget:self  action:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
//    [button setTitle:@"Show View" forState:UIControlStateNormal];
//    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
//    [_scrollView addSubview:button];
    

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
    [_crop setHidden:NO];
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

- (IBAction)effectOne:(id)sender {
    imageView.image = [image e1];
}

- (IBAction)effectTwo:(id)sender {
    imageView.image = [image e2];
}

- (IBAction)effectThree:(id)sender {
    imageView.image = [image e3];
}

- (IBAction)effectFour:(id)sender {
    imageView.image = [image e4];
}

- (IBAction)effectFive:(id)sender {
    imageView.image = [image e5];
}


- (void)ImageCropViewController:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
   image = croppedImage;
   imageView.image = croppedImage;
   
//    EffectsViewController *con = [[EffectsViewController alloc] initWithImage:image];
//    con.delegate = self;
//    [self.navigationController pushViewController:con animated:YES];

    
    //[self cropImage :croppedImage];
    
   [[self navigationController] popViewControllerAnimated:YES];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    int x = 0;
    for (int i = 1; i < 8; i++) {
//        UIBarButtonItem *button = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil
//                                       action:nil];
       // [button setTitle:<#(NSString *)#>]
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 100, 50)];
        //[button setTitle:[NSString stringWithFormat:@"Button %d", i] forState:UIControlStateNormal];
        NSString* aString = [NSString stringWithFormat:@"e%d", i];
        //button setImage:[image valueForKey:aString]];
        [button setImage:[image valueForKey:aString] forState:UIControlStateNormal];
       
        [button addTarget:self
                   action:NSSelectorFromString(aString)
                    forControlEvents:UIControlEventTouchUpInside];
      // [button setWidth:20];
        
        [scrollView addSubview:button];
        
       x += button.frame.size.width +10;
    }
    
    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor grayColor];
    [_measure setHidden:NO];
    [self.view addSubview:scrollView];
}

- (void)e1{
    imageView.image = [image e1];
}
- (void)e2{
    imageView.image = [image e2];
}
- (void)e3{
    imageView.image = [image e3];
}
- (void)e4{
    imageView.image = [image e4];
}
- (void)e5{
    imageView.image = [image e5];
}
- (void)e6{
    imageView.image = [image e6];
}
- (void)e7{
    imageView.image = [image e7];
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
- (IBAction)setMeasurements:(id)sender {
}
@end
