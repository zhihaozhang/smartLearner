//
//  ConnectUtil.h
//  brbb_teacher
//
//  Created by liuhaoxian on 12/13/13
//  Copyright (c) 2013 liuhaoxian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectUtil : NSObject
+(NSString*)getGET;
+(NSString*)getPOST;
//--------MMY
+(NSString*) getMY_NOTE;
+(NSString*) getADD_NOTE;
+(NSString*) getEXERCISE;
//--------MMY-----END
//由url得到NSData
+(NSDictionary*)getNSDataFromURL:(NSString*)baseUrl parameters:(NSArray*)params httpMethod:(NSString*)method;
//由url得到NSData
+(NSDictionary*)getNSDataFromURL:(NSString*)baseUrl parameters:(NSArray*)params;
+(NSDictionary*)httpPostSyn:(NSString *)baseUrl parameters:(NSArray*)params;
//对字符串进行URL编码
+(NSString *)StringEncode:(NSString*)str;

//对字符串进行URL解码
+(NSString *)StringDecode:(NSString*)str;

//URL编码
+(NSString *)URLEncode:(NSString*)baseUrl parameters:(NSArray*)params;
+(NSString *)URLMyEncode:(NSArray*)params;
//URL解码
+(NSArray *)URLDecode:(NSString *)url;

//全部课程列表
+(NSString*)getALLCLASS_HOME_LIST;
//点击课程后进入
+(NSString*)getVIDEOCLASSDETAIL;
//搜索课程
+(NSString*)getSEARCHCLASS;
//查看课程
+(NSString*)getADDCLASS;
@end
