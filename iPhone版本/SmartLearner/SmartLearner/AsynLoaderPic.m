//
//  AsynLoaderPic.m
//  krbb
//
//  Created by liuhaoxian on 4/11/14.
//  Copyright (c) 2014 ASELab. All rights reserved.
//

#import "AsynLoaderPic.h"

#import "ConnectUtil.h"
@implementation AsynLoaderPic
@synthesize picCache,directoryPath;

-(id)init:(NSString*)v_directory{
    
    self=[super init];
    if (self) {
        NSLog(@"init picCache");
        
        NSString* root=NSHomeDirectory();
        NSFileManager* manager=[NSFileManager defaultManager];
        //获取根目录
        self.directoryPath=[[root stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:v_directory];
        //如果不存在创建目录
        if (![manager fileExistsAtPath:self.directoryPath]) {
            [manager createDirectoryAtPath:self.directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        
        self.picCache=[[NSMutableDictionary alloc]initWithCapacity:200];
        
    }
    return self;
}

-(void)getPicFromURL:(NSString *)url UIImageView:(UIImageView *)imgView defaultImage:(NSString *)resName{
    UIImage* image=[self.picCache objectForKey:url];
    if (image) {
        NSLog(@"get pic from cache");
        imgView.image=image;
    }
    else{
        //设置默认图片
        imgView.image=[UIImage imageNamed:@"课程默认图片.png"];
        
        //替换：和/
        NSString* filename=[url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        filename=[filename stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        NSLog(@"filename=%@",filename);
        //先从本地获取
        UIImage* image=[UIImage imageWithContentsOfFile:[directoryPath stringByAppendingPathComponent:filename]];
        //本地没有图片
        if(image==nil)
        {
            NSArray* params=[[NSArray alloc]initWithObjects:url,imgView,nil];
            if (url==nil) {
                NSLog(@"url is nil");
            }
            if(imgView==nil){
                NSLog(@"imageView is nil");
            }
            [NSThread detachNewThreadSelector:@selector(createThreadToGetPic:) toTarget:self withObject:params];
        }
        else//本地存在图片
        {
             NSLog(@"get image from location");
            imgView.image=image;
            [self.picCache setObject:image forKey:url];
        }
    }
}

-(void)createThreadToGetPic:(NSArray*)params{
    NSLog(@"get image from network");
    NSString* url=[params objectAtIndex:0];
    UIImageView* imageView=[params objectAtIndex:1];
    NSURL* nsurl=[[NSURL alloc]initWithString:url];
    NSMutableURLRequest* request=[[NSMutableURLRequest alloc]initWithURL:nsurl cachePolicy:NSURLCacheStorageAllowed timeoutInterval:8];
    NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data!=nil) {
            UIImage* image=[UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image!=nil) {
                    //设置缓冲
                    [self.picCache setObject:image forKey:url];
                    imageView.image=image;
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    //替换：和/
                    NSString* filename=[url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
                    filename=[filename stringByReplacingOccurrencesOfString:@":" withString:@"_"];
                    //保存图片到directory目录下
                    [fileManager createFileAtPath:[directoryPath stringByAppendingPathComponent:filename] contents:data attributes:nil];
                    
                }
                else{
                    NSLog(@"get network image nil");
                }
            });
        }
        else
            NSLog(@"download fail");
}

-(void)dealloc{
    NSLog(@"picCache release");
   }
@end
