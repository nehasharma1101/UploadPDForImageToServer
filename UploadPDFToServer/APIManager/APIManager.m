
//sudipta

#import "APIManager.h"

@implementation APIManager
{
}

+ (APIManager *)sharedManagerWithDelegate:(id)delegate
{
    static APIManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        [sharedMyManager setDelegate:delegate];
    });
    return sharedMyManager;
}

- (void)startRequestWithURL:(NSURL *)url withRequestType:(APIManagerRequestType)requestType withDataDictionary:(NSDictionary *)dataDictionary CalledforMethod:(APIManagerCalledForMethodName)APImethodName
{
    if (url == nil || (requestType != kAPIManagerRequestTypeGET && requestType != kAPIManagerRequestTypePOST))
    {
        NSLog(@"Please call APIManager properly.");
        return;
    }
    networkManager = [AFHTTPRequestOperationManager manager];
    networkManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [networkManager.requestSerializer setTimeoutInterval :500];//500

    NSLog(@"APIManager start request");
    NSLog(@"%@", dataDictionary);

    if (requestType == kAPIManagerRequestTypeGET)
    {
        [networkManager GET:url.absoluteString parameters:dataDictionary
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"APIManager success.");
                        [self.delegate APIManagerDidFinishRequestWithData:responseObject withRequestType:requestType CalledforMethod:APImethodName tag:self.tag];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"APIManager error.");
                        [self.delegate APIManagerDidFinishRequestWithError:error withRequestType:requestType CalledforMethod:APImethodName tag:self.tag];
                    }];
    }
    else
    {
        [networkManager POST:url.absoluteString parameters:dataDictionary
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSLog(@"APIManager success.");
                         [self.delegate APIManagerDidFinishRequestWithData:(NSData *)responseObject withRequestType:requestType CalledforMethod:APImethodName tag:self.tag];
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"APIManager error.");
                         [self.delegate APIManagerDidFinishRequestWithError:error withRequestType:requestType CalledforMethod:APImethodName tag:self.tag];
                     }];
        
    }
}

-(void)cancelRequestWithURL:(NSURL *)url withRequestType:(APIManagerRequestType)requestType withDataDictionary:(NSDictionary *)dataDictionary CalledforMethod:(APIManagerCalledForMethodName)APImethodName
{
    [networkManager DELETE:url.absoluteString parameters:dataDictionary
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSLog(@"APIManager success.");
                    // [self.delegate APIManagerDidFinishRequestWithData:(NSData *)responseObject withRequestType:requestType CalledforMethod:APImethodName];
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"APIManager error.");
                    // [self.delegate APIManagerDidFinishRequestWithError:error withRequestType:requestType CalledforMethod:APImethodName];
                 }];
}
//extra
- (UIImage*)loadImage:(NSString *)strpath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      strpath];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}
-(NSData *)checksizeinmb:(UIImage *)resized_image
{
    NSData* data = UIImageJPEGRepresentation(resized_image, 0.9);
    NSUInteger imageSize = data.length;
      NSLog(@"SIZE OF IMAGE: %lu ", (unsigned long)imageSize);
    NSLog(@"SIZE OF IMAGE: %.2f Mb", (float)imageSize/1024/1024);
    NSData *imagedata;
    if ((float)imageSize/1024/1024>3)
    {
        imagedata=UIImageJPEGRepresentation(resized_image, 0.5);
    }
    else if ((float)imageSize/1024/1024>2)
    {
        imagedata=UIImageJPEGRepresentation(resized_image, 0.6);
    }
    else if ((float)imageSize/1024/1024>1)
    {
        imagedata=UIImageJPEGRepresentation(resized_image, 0.7);
    }
    else
    {
        imagedata=UIImageJPEGRepresentation(resized_image, 0.8);
    }
    return imagedata;
}

- (void)startRequestForImageUploadingWithURL:(NSURL *)url withRequestType:(APIManagerRequestType)requestType withDataDictionary:(NSDictionary *)dataDictionary arrImage:(NSMutableArray *)arrImage CalledforMethod:(APIManagerCalledForMethodName)APImethodName  index:(NSInteger)index isMultiple:(BOOL)isMultiple str_imagetype:(NSString*)str_imagetype
{
    NSString *strmsg;
    if (isMultiple==YES)
    {
         strmsg=[NSString stringWithFormat:@"Uploading %ld/%lu",(long)index,(unsigned long)arrImage.count];
        NSLog(@"countarr==%@",strmsg);

    }
    else
    {
       
    }
    
    if (url == nil || (requestType != kAPIManagerRequestTypeGET && requestType != kAPIManagerRequestTypePOST))
    {
        NSLog(@"Please call APIManager properly.");
        return;
    }
    networkManager=nil;
    networkManager = [AFHTTPRequestOperationManager manager];
    networkManager.requestSerializer.timeoutInterval=1000.0f;
    networkManager.requestSerializer = [AFJSONRequestSerializer serializer];
    networkManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [networkManager POST:url.absoluteString
              parameters:dataDictionary
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
        NSLog(@"timestampin milisec==%@",timestamp);
        if ([timestamp isEqualToString:@""]) {
            timestamp=@"12689654.08761";
        }
        NSData *dataimg;
         if (isMultiple==YES)
         {
             if ([str_imagetype isEqualToString:@"image"]) {
                 dataimg=[self checksizeinmb:[self loadImage:[arrImage objectAtIndex:index]]];
                 NSUInteger imageSize = dataimg.length;
                 //  NSLog(@"SIZE OF IMAGE: %lu ", (unsigned long)imageSize);
                 NSLog(@"SIZE OF IMAGE12: %.2f Mb", (float)imageSize/1024/1024);
             }
             else
             {
               // dataimg = [[arrImage objectAtIndex:index] dataUsingEncoding:NSUTF8StringEncoding];
                 dataimg =  [[NSData alloc] initWithContentsOfURL:[arrImage objectAtIndex:index]];
             }
          ////need
            
         }
        else
        {
            if ([str_imagetype isEqualToString:@"image"]) {
                //dataimg=[self checksizeinmb:[self loadImage:[arrImage objectAtIndex:index]]];
                dataimg=[self checksizeinmb:[arrImage objectAtIndex:index]];
                NSUInteger imageSize = dataimg.length;
                //  NSLog(@"SIZE OF IMAGE: %lu ", (unsigned long)imageSize);
                NSLog(@"SIZE OF IMAGE12: %.2f Mb", (float)imageSize/1024/1024);
            }
            else
            {
              //  dataimg = [[arrImage objectAtIndex:index] dataUsingEncoding:NSUTF8StringEncoding];
                 dataimg =  [[NSData alloc] initWithContentsOfURL:[arrImage objectAtIndex:index]];
            }
        }
        if (dataimg) {
            if ([str_imagetype isEqualToString:@"image"])
            {
            [formData appendPartWithFileData:dataimg name:@"file" fileName:[NSString stringWithFormat:@"files_%@.jpg",timestamp] mimeType:@"image/jpeg"];
            }
            else
            {
            [formData appendPartWithFileData:dataimg name:@"file" fileName:[NSString stringWithFormat:@"files_%@.pdf",timestamp] mimeType:@"application/pdf"];
            }
        }
        else
        {
            NSLog(@"image size is very large");
         
             [self.delegate APIManagerDidFinishRequestWithData:(NSData *)nil withRequestType:requestType CalledforMethod:APImethodName tag:self.tag];
        }
        }
   
    success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
         NSDictionary *dictResponse = (NSDictionary *)responseObject;
        NSLog(@"dictResponse...%@",dictResponse);
         NSInteger i=index;
         i=i+1;
         if (i<arrImage.count)
         {
              NSLog(@"test sucees");
             [self startRequestForImageUploadingWithURL:(NSURL *)url withRequestType:(APIManagerRequestType)requestType withDataDictionary:(NSDictionary *)dataDictionary arrImage:(NSMutableArray *)arrImage CalledforMethod:(APIManagerCalledForMethodName)APImethodName index:i isMultiple:YES str_imagetype:@"image"];
         }
         else
         {
             if (isMultiple==YES)
             {
             }
            
             NSLog(@"test sucees");
             [self.delegate APIManagerDidFinishRequestWithData:(NSData *)responseObject withRequestType:requestType CalledforMethod:APImethodName tag:self.tag];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
          NSLog(@"test falid");
         [self.delegate APIManagerDidFinishRequestWithError:error withRequestType:requestType CalledforMethod:APImethodName tag:self.tag];
     }];
}
- (void)CancelAllRequest
{
    //AFHTTPRequestOperationManager *networkManager = [AFHTTPRequestOperationManager manager];
    [networkManager.operationQueue cancelAllOperations];
}

@end
