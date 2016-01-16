//
//  ConnectUtil.m
//  krbb_teacher
//
//  Created by liuhaoxian on 12/13/13
//  Copyright (c) 2013 liuhaoxian. All rights reserved.
//

#import "ConnectUtil.h"
#import "URLParamter.h"
@implementation ConnectUtil
static NSString* baseUrl=@"http://120.24.94.254:8181/index.php/";
//网络请求方式
static NSString* GET=@"GET";
static NSString* POST=@"POST";
static NSString* MY_NOTE =@"note/mynote";
static NSString* ADD_NOTE =@"note/add";
static NSString* EXERCISE = @"exercises";
// 获取我的笔记
+(NSString*) getMY_NOTE{
    return [baseUrl stringByAppendingString:MY_NOTE];
}
// 新建我的笔记
+(NSString*) getADD_NOTE{
    return [baseUrl stringByAppendingString:ADD_NOTE];
}
// 获取习题
+(NSString*) getEXERCISE{
    return [baseUrl stringByAppendingString:EXERCISE];
}
+(NSString*)getGET{
    return GET;
}
+(NSString*)getPOST{
    return POST;
}

//全部课程列表
+(NSString*)getALLCLASS_HOME_LIST{
    return [baseUrl stringByAppendingString:@"curriculum"];
}
//点击课程后进入
+(NSString*)getVIDEOCLASSDETAIL{
    return [baseUrl stringByAppendingString:@"curriculum/page"];
}
//搜索课程
+(NSString*)getSEARCHCLASS{
    return [baseUrl stringByAppendingString:@"/curriculum/search"];
}
//查看课程
+(NSString*)getADDCLASS{
    return [baseUrl stringByAppendingString:@"/curriculum/add"];
}
+(NSDictionary*)getNSDataFromURL:(NSString *)baseUrl parameters:(NSArray*)params httpMethod:(NSString *)method
{
    //解决中文乱码问题
    NSString* url=[self URLEncode:baseUrl parameters:params];
    
    NSLog(@"url-------->%@",url);
   /* //由url得到NSData
    NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    */
    NSURL* nsurl=[[NSURL alloc]initWithString:url];
    
    NSMutableURLRequest* request=[[NSMutableURLRequest alloc]initWithURL:nsurl cachePolicy:NSURLCacheStorageAllowed timeoutInterval:8];
   [request setHTTPMethod:method];
    NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError* error;
    
    NSDictionary* dict=nil;
    if (data!=nil) {
        dict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
//    NSLog(@"get dictionary is %@",dict);
    //[nsurl release];
    //[request release];
    return dict;
}

+(NSDictionary*)getNSDataFromURL:(NSString *)baseUrl parameters:(NSArray*)params
{
    
   
    //解决中文乱码问题
    NSString* url=[self URLEncode:baseUrl parameters:params];
    
    NSLog(@"url-------->%@",url);
    /* //由url得到NSData
     NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
     */
    NSURL* nsurl=[[NSURL alloc]initWithString:url];
    
    NSMutableURLRequest* request=[[NSMutableURLRequest alloc]initWithURL:nsurl cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError* error;
    
    NSDictionary* dict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //[nsurl release];
    //[request release];
    return dict;
}
+(NSDictionary*)httpPostSyn:(NSString *)baseUrl parameters:(NSArray*)params
{
    NSLog(@"httpPostSyn...");
    
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:baseUrl];
    //NSString* url=baseUrl;
    
    //第二步，创建请求
    NSString *postStr = [self URLMyEncod: params];
    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    [request setHTTPBody:postData];//设置参数
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError* error;
    NSLog(@"httpPostSyn......%@",received);
    NSDictionary* dict=[NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:&error];
    //NSString *backStr = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    return dict;
}


+(NSString *)StringEncode:(NSString*)str
{
    if (str==nil) {
        return @"";
    }
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned  char *)[str UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

+(NSString *)StringDecode:(NSString*)str
{
    return [[str stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+(NSString *)URLEncode:(NSString*)baseUrl parameters:(NSArray*)params
{
    NSString *url = baseUrl;
    if(url==nil||params==nil)
        return url;
    if([params count] > 0)
    {
        url = [url stringByAppendingString:@"?"];
    }
    
    BOOL isFirst = YES;
    for(URLParamter* param in params)
    {
        if(isFirst)
        {
            isFirst = NO;
        }
        else
        {
            url = [url stringByAppendingString:@"&"];
        }
        url = [url stringByAppendingFormat:@"%@=%@", [self StringEncode:param.key], [self StringEncode:param.value]];
    }
    return url;
}
+(NSString *)URLMyEncod:(NSArray*)params
{
    NSString *url = @"";
    if(url==nil||params==nil)
        return url;
    BOOL isFirst = YES;
    for(URLParamter* param in params)
    {
        if(isFirst)
        {
            isFirst = NO;
        }
        else
        {
            url = [url stringByAppendingString:@"&"];
        }
        url = [url stringByAppendingFormat:@"%@=%@", [self StringEncode:param.key], [self StringEncode:param.value]];
    }
    return url;
}
+(NSArray *)URLDecode:(NSString *)url
{
    NSRange range = [url rangeOfString:@"?"];
    if(range.location == NSNotFound)
    {
        return @[url, [NSNull null]];
    }
    
    NSString *baseUrl = [url substringToIndex:range.location - 1];
    NSString *dataUrl = [url substringFromIndex:range.location + 1];
    
    NSArray *parameters = [dataUrl componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:parameters.count];
    for(NSString *pa in parameters)
    {
        NSArray *pair = [pa componentsSeparatedByString:@"="];
        NSString *key = [self StringDecode:[pair objectAtIndex:0]];
        NSString *val = [self StringDecode:[pair objectAtIndex:1]];
        
        [dic setValue:val forKey:key];
    }
    return @[baseUrl, dic];
}

@end
