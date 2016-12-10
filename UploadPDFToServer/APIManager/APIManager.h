//sudipta


//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#import "AppDelegate.h"

typedef enum
{
    kAPIManagerRequestTypeGET,
    kAPIManagerRequestTypePOST
} APIManagerRequestType;

typedef enum {
       //GoogleAppUserList
    imageupload
    
} APIManagerCalledForMethodName;



@protocol APIManagerDelegate <NSObject>

@required
- (void) APIManagerDidFinishRequestWithData:(id)responseData withRequestType:(APIManagerRequestType)requestType CalledforMethod:(APIManagerCalledForMethodName)APImethodName tag:(NSInteger)tag;
- (void) APIManagerDidFinishRequestWithError:(NSError *)error withRequestType:(APIManagerRequestType)requestType CalledforMethod:(APIManagerCalledForMethodName)APImethodName tag:(NSInteger)tag;
@end

@interface APIManager : NSObject
{
    AFHTTPRequestOperationManager *networkManager;
}

@property (nonatomic, retain) id <APIManagerDelegate> delegate;
@property NSInteger tag;
+ (APIManager *)sharedManagerWithDelegate:(id)delegate;
- (void) startRequestWithURL:(NSURL *)url
             withRequestType:(APIManagerRequestType)requestType
          withDataDictionary:(NSDictionary *)dataDictionary CalledforMethod:(APIManagerCalledForMethodName)APImethodName;

- (void) cancelRequestWithURL:(NSURL *)url
             withRequestType:(APIManagerRequestType)requestType
          withDataDictionary:(NSDictionary *)dataDictionary CalledforMethod:(APIManagerCalledForMethodName)APImethodName;

- (void)startRequestForImageUploadingWithURL:(NSURL *)url withRequestType:(APIManagerRequestType)requestType withDataDictionary:(NSDictionary *)dataDictionary arrImage:(NSMutableArray *)arrImage CalledforMethod:(APIManagerCalledForMethodName)APImethodName  index:(NSInteger)index isMultiple:(BOOL)isMultiple str_imagetype:(NSString*)str_imagetype;

- (void)CancelAllRequest;


@end
