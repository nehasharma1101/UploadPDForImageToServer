//
//  ViewController.m
//  UploadPDFToServer
//
//  Created by Rajesh K G on 10/12/16.
//  Copyright © 2016 INDGlobal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    arrimg =[[NSMutableArray alloc]init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Choose File or Image
- (IBAction)browseFile:(id)sender
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Photo option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take Photo ",
                            @"Choose Existing",@"Document",nil];
    
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma  mark- Opne Action Sheet for Options

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    
                    imagePicker = [[UIImagePickerController alloc] init];
                    
                    // Set source to the camera
                    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                    
                    // Delegate is self
                    imagePicker.delegate = self;
                    
                    // Allow editing of image ?
                    
                    
                    // Show image picker
                    
                    
                    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
                    [self presentViewController:imagePicker animated:YES completion:nil];
                    
                    
                    break;
                case 1:
                    
                    imagePicker = [[UIImagePickerController alloc] init];
                    
                    imagePicker.delegate = self;
                    
                    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
                    
                    [self presentViewController:imagePicker animated:YES completion:nil];
                    
                    break;
                    
                case 2:
                    
                    [self showDocumentPickerInMode:UIDocumentPickerModeOpen];
                    
                    
                    
                    break;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark- Open Document Picker(Delegate) for PDF, DOC Slection from iCloud


- (void)showDocumentPickerInMode:(UIDocumentPickerMode)mode
{
    
    UIDocumentMenuViewController *picker =  [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"com.adobe.pdf"] inMode:UIDocumentPickerModeImport];
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}


-(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker
{
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller
  didPickDocumentAtURL:(NSURL *)url
{
    PDFUrl= url;
    UploadType=@"PDF";
    [arrimg removeAllObjects];
    [arrimg addObject:url];
    
}

#pragma mark- Open Image Picker Delegate to select image from Gallery or Camera
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UploadType=@"Image";
    [arrimg removeAllObjects];
    [arrimg addObject:myImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark - Upload Image, PDF or Doc to Server

- (IBAction)submit:(id)sender
{
    
    if ([UploadType isEqualToString:@"PDF"])
    {
        [self uploadpdf];
    }
    
    else
        
       [self uploadimage];
}


#pragma mark - Upload Image

-(void)uploadimage
{
    //loader start
    APIManager *obj =[[APIManager alloc]init];
    [obj setDelegate:(id)self];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setValue:@"SOME PARAMETER" forKey:@"type"];
    [dict setValue:@"SOME PARAMETER" forKey:@"title"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@",@"API URL"];
    NSURL *url =[NSURL URLWithString:urlString];
    [obj startRequestForImageUploadingWithURL:url withRequestType:(kAPIManagerRequestTypePOST) withDataDictionary:dict arrImage:arrimg CalledforMethod:imageupload index:0 isMultiple:NO str_imagetype:@"image"];
}

#pragma mark - Upload PDF

-(void)uploadpdf
{
    APIManager *obj =[[APIManager alloc]init];
    [obj setDelegate:(id)self];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setValue:@"SOME PARAMETER" forKey:@"type"];
    [dict setValue:@"SOME PARAMETER" forKey:@"title"];
    NSString *urlString = [NSString stringWithFormat:@"%@",@"API URL"];
    NSURL *url =[NSURL URLWithString:urlString];
    [obj startRequestForImageUploadingWithURL:url withRequestType:(kAPIManagerRequestTypePOST) withDataDictionary:dict arrImage:arrimg CalledforMethod:imageupload index:0 isMultiple:NO str_imagetype:@"pdf"];
    
}

#pragma mark-API Manager Delegate Method for Succes or Failure


-(void)APIManagerDidFinishRequestWithData:(id)responseData withRequestType:(APIManagerRequestType)requestType CalledforMethod:(APIManagerCalledForMethodName)APImethodName tag:(NSInteger)tag
{
    if (APImethodName ==imageupload) {
        NSDictionary *responsedata=(NSDictionary*)responseData;
        NSLog(@"data==%@",responsedata);
        
        NSString * Success= [responsedata valueForKey:@"success"];
        NSString * Message= [responseData valueForKey:@"message"];
        
        BOOL SuccessBool= [Success boolValue];
        
        if (SuccessBool)
        {
            
            //[self.navigationController popViewControllerAnimated:YES];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Server Error" message:Message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                                                  }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

-(void)APIManagerDidFinishRequestWithError:(NSError *)error withRequestType:(APIManagerRequestType)requestType CalledforMethod:(APIManagerCalledForMethodName)APImethodName tag:(NSInteger)tag
{
    if (APImethodName ==imageupload) {
        NSLog(@"image didfailedupload");
    }
}

@end
