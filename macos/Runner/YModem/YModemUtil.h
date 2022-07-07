//
//  YModemUtil.h
//  Runner
//
//  Created by RND on 2021/12/3.
//

#import <Foundation/Foundation.h>
#import "YModem.h"


typedef enum : NSUInteger {
    OTAStatusNONE,
    OTAStatusWaiting,
    OTAStatusFirstOrder,
    OTAStatusBinOrder,
    OTAStatusBinOrderDone,
    OTAStatusEnd,
    OTAStatusCAN,
    OTAStatusEOT,
} OTAStatus;

typedef enum : NSUInteger {
    OrderStatusNONE,
    OrderStatusC,
    OrderStatusACK,
    OrderStatusNAK,
    OrderStatusCAN,
    OrderStatusFirst,
} OrderStatus;


//setting delegate method
@protocol YModemUtilDelegate <NSObject>

//write bluetooth data
-(void)onWriteBleData:(NSData*) data;

@end

@interface YModemUtil : NSObject

- (instancetype)init:(uint32_t) size;

@property (nonatomic, weak) id<YModemUtilDelegate> delegate;

@property (nonatomic, strong) NSArray  *packetArray;

@property (nonatomic, assign) OTAStatus status;

- (void)setFirmwareHandleOTADataWithOrderStatus:(OrderStatus)status fileName:(NSString *)filename filePath:(NSString *)filepath completion:(void(^)(NSInteger current,NSInteger total,NSString *msg,NSData *datas))complete;

- (NSData *)prepareFirstPacketWithFileName:(NSString *)filename;

-(void)stopUpgrade:(void(^)(NSInteger current,NSInteger total,NSString *msg,NSData *datas))complete;

-(void)initBegin;



@end
