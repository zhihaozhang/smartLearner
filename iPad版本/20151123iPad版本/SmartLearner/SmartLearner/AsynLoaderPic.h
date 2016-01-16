//
//  AsynLoaderPic.h
//  krbb
//
//  Created by liuhaoxian on 4/11/14.
//  Copyright (c) 2014 ASELab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AsynLoaderPic : NSObject

@property(nonatomic,strong)NSMutableDictionary* picCache;
@property(nonatomic,strong)NSString* directoryPath;

-(id)init:(NSString*)v_directory;
-(void)getPicFromURL:(NSString*)url UIImageView:(UIImageView*)imgView defaultImage:(NSString*)resName;


@end
