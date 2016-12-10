//
//  ViewController.h
//  UploadPDFToServer
//
//  Created by Rajesh K G on 10/12/16.
//  Copyright © 2016 INDGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"

@interface ViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,APIManagerDelegate,UIDocumentPickerDelegate, UIDocumentMenuDelegate>

{
    UIDocumentPickerViewController *docPicker;
    UIImagePickerController *imagePicker;
    NSMutableArray *arrimg;
    
    NSString * UploadType;
    NSURL * PDFUrl;

}

- (IBAction)browseFile:(id)sender;






@end

