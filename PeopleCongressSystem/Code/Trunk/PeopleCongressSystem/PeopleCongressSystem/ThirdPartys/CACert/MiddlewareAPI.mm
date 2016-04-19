//
//  MiddlewareAPI.m
//  DCidentification
//
//  Created by 孙腾 on 16/1/19.
//  Copyright © 2016年 MyMac. All rights reserved.
//

#import "MiddlewareAPI.h"
#include "lnca_crypto.h"

@implementation MiddlewareAPI


static MiddlewareAPI * shareAPI = nil;

+(MiddlewareAPI * ) instance
{
    if(shareAPI == nil)
    {
        shareAPI = [[MiddlewareAPI alloc] init];
        [shareAPI initMiddleware];
    }
    return shareAPI;
}

//初始化
-(Boolean)initMiddleware
{
    
    NSArray * arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * strPath = [arr objectAtIndex:0];
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"lnca" ofType:@"db"];
    strPath = dbPath.stringByDeletingLastPathComponent;
    
    strPath = [NSString stringWithFormat: @"%@/", strPath];
//
//    NSData *data = [NSData dataWithContentsOfFile:dbPath];
//    [data writeToFile:[strPath stringByAppendingPathComponent:@"lnca.db"] atomically:true];
    
    
    _nRet = LNCA_lib_Init_withPath((char *)[strPath UTF8String]);
    
    NSLog(@"MiddlewareAPI > initMiddleware > LNCA_lib_Init_withPath > result: %@", _nRet == 0 ? @"success" : @"error");
    
    return _nRet = 0;
}


//通过id和类型(rsa证书：1；sm2证书：2)获取证书
-(NSString *)getCertByID :(NSString *) certID :(int) certType
{
    char szID[128] = {0};
    char * pszCert = NULL;
    int nCertLen = 0;
    
    strcpy(szID, [certID UTF8String]);
    
    _nRet = LNCA_GetCertByID(szID, certType, pszCert, &nCertLen);
    NSLog(@"MiddlewareAPI > getCertByID > LNCA_GetCertByID result: %@", _nRet == 0 ? @"success" : @"error");
    
    pszCert = (char *)malloc(nCertLen + 1);
    memset(pszCert, 0, nCertLen + 1);
    _nRet = LNCA_GetCertByID(szID, certType, pszCert, &nCertLen);
    NSLog(@"MiddlewareAPI > getCertByID > LNCA_GetCertByID result: %@", _nRet == 0 ? @"success" : @"error");
    
    _signCert = new char[nCertLen + 1];
    memset(_signCert, 0, nCertLen + 1);
    memcpy(_signCert, pszCert , nCertLen);
    
    _signCertLen = nCertLen;
    
    NSData * pData = [NSData dataWithBytes: pszCert length: nCertLen];
    NSString * pstrBase64 = [pData base64EncodedStringWithOptions: 0];
    
    return pstrBase64;
}


//签名
-(NSString *)signByID :(NSString *) certID :(NSString *) signData
{
    [self getCertByID:certID :1];//获取签名证书
    
    char szData[1024] = {0};
    int nDataLen = 1024;
    
    char szSign[1024] = {0};
    int nSignLen = 0;
    
    strcpy(szData, [signData UTF8String]);
    nDataLen = (int)strlen(szData);
    
    _nRet = LNCA_Sign((unsigned char *)_signCert, _signCertLen, (unsigned char *)szData, nDataLen, (unsigned char *)szSign, &nSignLen);
    NSLog(@"sign result: %@", _nRet == 0 ? @"success" : @"error");
    
    NSData * pData = [NSData dataWithBytes: szSign length: nSignLen];
    NSString * pstrBase64 = [pData base64EncodedStringWithOptions: 0];
    
    return pstrBase64;
}
@end
