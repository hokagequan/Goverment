//
//  MiddlewareAPI.h
//  DCidentification
//
//  Created by 孙腾 on 16/1/19.
//  Copyright © 2016年 MyMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiddlewareAPI : NSObject
{
    int _nRet;//操作结果
    char * _signCert;//签名证书
    int _signCertLen;//签名证书长度
}

+(MiddlewareAPI * ) instance;

//初始化
-(Boolean)initMiddleware;

//通过id和类型(rsa证书：1；sm2证书：2)获取证书
-(NSString *)getCertByID :(NSString *) certID :(int) certType;

//签名
-(NSString *)signByID :(NSString *) certID :(NSString *) signData;


@end
