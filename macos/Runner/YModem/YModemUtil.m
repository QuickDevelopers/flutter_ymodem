//
//  YModemUtil.m
//  Runner
//
//  Created by RND on 2021/12/3.
//

#import "YModemUtil.h"

@interface YModemUtil(){
    int index_packet;
    int index_packet_cache;
    uint32_t sendSize;
}
@end

@implementation YModemUtil

- (instancetype)init:(uint32_t) size
{
    self = [super init];
    if (self) {
        self.status = OTAStatusNONE;
        index_packet = 0;
        index_packet_cache = -1;
        sendSize = size;
        //self.packetArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)initBegin{
    self.status = OTAStatusNONE;
    index_packet = 0;
    index_packet_cache = -1;
    //sendSize = size;
}


#pragma mark - Data transmission and processing of lower computer
- (void)setFirmwareHandleOTADataWithOrderStatus:(OrderStatus)status fileName:(NSString *)filename filePath:(NSString *)filepath completion:(void(^)(NSInteger current,NSInteger total,NSString *msg,NSData *datas))complete{
    NSString *msgg=@"run";
    NSData *data1 = nil;
    switch (status) {
        //Send Head Package
        case OrderStatusC:{
            NSData *data_first = [self autoFirstPacketWithFileName:filename filePath:filepath];
            data1 = data_first;
            if([self.delegate respondsToSelector:@selector(onWriteBleData:)]){
                [self.delegate onWriteBleData:data_first];
            }
            
            self.status = OTAStatusFirstOrder;
            
            break;
        }
            
        //Send First Package
        case OrderStatusFirst:{
            if(self.status == OTAStatusFirstOrder){
                //msgg=@"开始发送第一包";
                // 正式包数组 获取所有拆解包放入数组中存储
                if (index_packet != index_packet_cache) {
                    if (!self.packetArray) {
                        self.packetArray = [self autoPacketWithFile:filename filePath:filepath];
                    }
                    NSData *data = self.packetArray[index_packet];
                    data1 = data;
                    //NSLog(@"data is %@",data);
                    
                    //写入蓝牙数据
                    if([self.delegate respondsToSelector:@selector(onWriteBleData:)]){
                        [self.delegate onWriteBleData:data];
                    }
                    index_packet_cache = index_packet;
                    self.status = OTAStatusBinOrder;
                }
            }
            
            //结束包的时候
            if(self.status == OTAStatusBinOrderDone){
                if(index_packet >= self.packetArray.count){
                    NSData *data = [self prepareEndPacket];
                    data1 = data;
                    if([self.delegate respondsToSelector:@selector(onWriteBleData:)]){
                        [self.delegate onWriteBleData:data];
                    }
                    //index_packet = OTAUPEND;
                }
                msgg = @"Finish";
                //end
                self.status = OTAStatusEnd;
                
                // 最后的时候
                self.status = OTAStatusNONE;
                index_packet = 0;
                index_packet_cache = -1;
            }
            
            break;
        }
            
        case OrderStatusACK:{
            if(self.status == OTAStatusBinOrder){
                index_packet++;
                if (index_packet < self.packetArray.count) {
                    if (index_packet != index_packet_cache) {
                        if (!self.packetArray) {
                            self.packetArray = [self autoPacketWithFile:filename filePath:filepath];
                        }
                        NSData *data = self.packetArray[index_packet];
                        data1 = data;
                        //send unpacking
                        if([self.delegate respondsToSelector:@selector(onWriteBleData:)]){
                            //NSLog(@"data is %@",data);
                            [self.delegate onWriteBleData:data];
                            
                        }
                        [NSThread sleepForTimeInterval:0.02];
                    }
                    index_packet_cache = index_packet;
                    self.status = OTAStatusBinOrder;
                }else{
                    
                    // After all official document packages are sent, the OTA command is sent to end
                    Byte byte4[] = {0x04};
                    NSData *data23 = [NSData dataWithBytes:byte4 length:sizeof(byte4)];
                    data1 = data23;
                    if([self.delegate respondsToSelector:@selector(onWriteBleData:)]){
                        [self.delegate onWriteBleData:data23];
                    }
                    self.status = OTAStatusEOT;
                }
            }
            break;
        }
            
        case OrderStatusNAK:{
            NSLog(@"this is indexpacket %d",index_packet);
            if(self.status == OTAStatusEOT){
                if(index_packet >= self.packetArray.count){
                    Byte byte4[] = {0x04};
                    NSData *data23 = [NSData dataWithBytes:byte4 length:sizeof(byte4)];
                    data1 = data23;
                    if([self.delegate respondsToSelector:@selector(onWriteBleData:)]){
                        [self.delegate onWriteBleData:data23];
                    }
                    self.status = OTAStatusBinOrderDone;
                }
            }else{
                msgg=@"OTA Upgared Fail...";
                //[self stopOtaUpgrad];
                Byte stop[] = {0x18};
                NSData *data = [NSData dataWithBytes:stop length:sizeof(stop)];
                data1 = data;
            }
            break;
        }
        default:
            break;
    }
    
    if(self.packetArray.count>0){
        complete(index_packet,self.packetArray.count,msgg,data1);
    }else{
        complete(index_packet,0,msgg,data1);
    }
}


/*
 stop upgrade
 */
-(void)stopUpgrade:(void(^)(NSInteger current,NSInteger total,NSString *msg,NSData *datas))complete{

    self.status = OTAStatusNONE;
    self->index_packet = 0;
    self->index_packet_cache = -1;
    
    Byte stop[] = {0x18};
    NSData *data = [NSData dataWithBytes:stop length:sizeof(stop)];
    if([self->_delegate respondsToSelector:@selector(onWriteBleData:)]){
        [self.delegate onWriteBleData:data];
    }
    complete(0,0,@"stopOta",data);
}





/*
 Length 133
 Send firstpacket data
 @author ardwang
 @date dec 8 2021
 return nsdata
 */
- (NSData *)prepareFirstPacketWithFileName:(NSString *)filename {
    // file name
    NSString *room_name = filename;
    NSData* bytes = [room_name dataUsingEncoding:NSUTF8StringEncoding];
    Byte * myByte = (Byte *)[bytes bytes];
    UInt8 buff_name[bytes.length+1];
    memcpy(buff_name, [room_name UTF8String],[room_name lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + 1);
    //|UTF8String|return\0  |lengthOfBytesUsingEncoding|calculation don't include\0 so this in add one
    // file size
    NSMutableData *file = [[NSMutableData alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:room_name];
    
    file = [NSMutableData  dataWithContentsOfFile:path];
    uint32_t length = (uint32_t)file.length;
    
    // send SOH data packet
    // Build package
    UInt8 *buff_data;
    buff_data = (uint8_t *)malloc(sizeof(uint8_t)*133);
    
    UInt8 *crc_data;
    crc_data = (uint8_t *)malloc(sizeof(uint8_t)*128);
    
    PrepareIntialPacket(buff_data, myByte, length);
    
    NSData *data_first = [NSData dataWithBytes:buff_data length:sizeof(uint8_t)*133];
    
    return data_first;
}


/**
    Length 133
    Send firstpacket data
    @author ardwang
    @date dec 8 2021
    return nsdata
 */
-(NSData *)autoFirstPacketWithFileName:(NSString *) filename filePath:(NSString *) filepath{
    // file name
    NSString *room_name = filename;
    NSData* bytes = [room_name dataUsingEncoding:NSUTF8StringEncoding];
    Byte * myByte = (Byte *)[bytes bytes];
    UInt8 buff_name[bytes.length+1];
    memcpy(buff_name, [room_name UTF8String],[room_name lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + 1);
    //|UTF8String|return\0  |lengthOfBytesUsingEncoding|calculation don't include\0 so this in add one
    // file size
    NSMutableData *file = [[NSMutableData alloc]init];
    file = [NSMutableData  dataWithContentsOfFile:filepath];
    uint32_t length = (uint32_t)file.length;
    
    // send SOH data packet
    // generate
    UInt8 *buff_data;
    buff_data = (uint8_t *)malloc(sizeof(uint8_t)*133);
    
    UInt8 *crc_data;
    crc_data = (uint8_t *)malloc(sizeof(uint8_t)*128);
    
    PrepareIntialPacket(buff_data, myByte, length);
    
    NSData *data_first = [NSData dataWithBytes:buff_data length:sizeof(uint8_t)*133];
    
    return data_first;
    
}


/**
 Automatic unpacking note: the packet size I negotiated with the bottom layer is 256 instead of 1024. Generally, it is 1024
 Length 128
 How many packages are automatically unpacked according to the file size
 
 use filename and filepath
 @author ardwang
 @date dec 8 2021
 return NSArray
 */
-(NSArray *)autoPacketWithFile:(NSString *)filename filePath:(NSString *) filepath{
    NSMutableData *file = [[NSMutableData alloc] init];
    file = [NSMutableData dataWithContentsOfFile:filepath];
    
    uint32_t size = file.length>=sendSize?(sendSize):(PACKET_SIZE);
    // unpacking
    int index = 0;
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i<file.length; i++) {
        if (i%size == 0) {
            index++;
            uint32_t len = size;
            if ((file.length-i)<size) {
                len = (uint32_t)file.length - i;
            }
            //Intercept n or 128 length data
            NSData *sub_file_data = [file subdataWithRange:NSMakeRange(i, len)];
            
            uint32_t sub_size = sendSize;
            Byte *sub_file_byte = (Byte *)[sub_file_data bytes];
            uint8_t *p_packet;
            p_packet = (uint8_t *)malloc(sub_size+5);
            PreparePacket(sub_file_byte, p_packet, index, sendSize, (uint32_t)sub_file_data.length);
            
            NSData *data_ = [NSData dataWithBytes:p_packet length:sizeof(uint8_t)*(sub_size+5)];
            
            [dataArray addObject:data_];
        }
    }
    return dataArray;
}



/*
 Automatic unpacking note: the packet size I negotiated with the bottom layer is 256 instead of 1024. Generally, it is 1024
 Length 128
 How many packages are automatically unpacked according to the file size
 */
- (NSArray *)preparePacketWithFileName:(NSString *)filename{
    NSString *room_name = filename;
    // file size
    NSMutableData *file = [[NSMutableData alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:room_name];
    file = [NSMutableData dataWithContentsOfFile:path];
    uint32_t size = file.length>=sendSize?(sendSize):(PACKET_SIZE);
    // Unpacking
    int index = 0;
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i<file.length; i++) {
        if (i%size == 0) {
            index++;
            uint32_t len = size;
            if ((file.length-i)<size) {
                len = (uint32_t)file.length - i;
            }
            // Intercept n or 128 length data
            NSData *sub_file_data = [file subdataWithRange:NSMakeRange(i, len)];
            
            uint32_t sub_size = sendSize;
            Byte *sub_file_byte = (Byte *)[sub_file_data bytes];
            uint8_t *p_packet;
            p_packet = (uint8_t *)malloc(sub_size+5);
            PreparePacket(sub_file_byte, p_packet, index, sendSize, (uint32_t)sub_file_data.length);
            
            NSData *data_ = [NSData dataWithBytes:p_packet length:sizeof(uint8_t)*(sub_size+5)];
            
            [dataArray addObject:data_];
        }
    }
    return dataArray;
}

/*
 Send the end package, complete the OTA upgrade, and send it according to your own agreement
 */
- (NSData *)prepareEndPacket {
    UInt8 *buff_data;
    buff_data = (uint8_t *)malloc(sizeof(uint8_t)*(PACKET_SIZE+5));
    PrepareEndPacket(buff_data);
    NSData *data_first = [NSData dataWithBytes:buff_data length:sizeof(uint8_t)*(PACKET_SIZE+5)];
    return data_first;
}

@end
