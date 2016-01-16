//
//  URLParamter.m
//  krbb_teacher
//
//  Created by liuhaoxian on 12/13/13.
//  Copyright (c) 2013 liuhaoxian. All rights reserved.
//

#import "URLParamter.h"

@implementation URLParamter
@synthesize key;
@synthesize value;
-(id)initWithKey:(NSString *)_key value:(NSString *)_value
{
    self=[super init];
    if(self)
    {
        self.key=_key;
        self.value=_value;
    }
    return self;
}
-(void)dealloc
{
}
@end
