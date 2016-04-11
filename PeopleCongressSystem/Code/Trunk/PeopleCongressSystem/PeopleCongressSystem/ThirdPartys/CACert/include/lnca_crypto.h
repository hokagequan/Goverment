/*************************************
 说明：手机安全平台接口，头文件
	日期：2015-11-23
 **************************************/
#ifndef _LNCA_CRYPT_H_
#define _LNCA_CRYPT_H_

#include <stdio.h>

#include "openssl/x509.h"
#include "MemSelfFree.h"
#include "SSLMemSelfFree.h"
#ifdef WIN32
#ifdef	LNCA_EXPORTS
#define LNCA_API __declspec(dllexport)
#else
#define LNCA_API __declspec(dllimport)
#endif
#else
#define LNCA_API
#endif

#ifndef __BUFFER_STRUCT__
#define __BUFFER_STRUCT__

struct buffer_struct
{
    long		length;//数据长度
    unsigned char		*szBuf;//数据
};
typedef struct buffer_struct  buffer_st;

#endif

//私有数据结构
typedef struct ST_Cert
{
    CMemSelfFree msprivatekey;
    CMemSelfFree msencprikey;
    CMemSelfFree mspublickey;
    CMemSelfFree mspublickeyhash;
    CMemSelfFree mscert;
    CMemSelfFree msEncpublickey;
    char strsn[128];
    char strissuser[256];
    char struser[256];
    char strtime[32];
    int SignAlgo;
    int itype;
} STCERTINFO;


//so初始化
int LNCA_lib_Init();
int LNCA_lib_Init_withPath(char* szWorkPath);
int LNCA_lib_Release();

//SHA1文摘
unsigned char * LNCA_SHA1(unsigned char *d, unsigned long n, unsigned char *md);

//产生申请书
int LNCA_GenReq(char* szDN, int itype,int iDoubleCert, char*szoutID,char * szoutSignReq, int* pnoutSignReqLen,
                char * szoutEncReq, int* pnoutEncReqLen);

//证书注入
int LNCA_ImportCert(char* szID, char* szSignp7b, int nSignp7bLen, char*szEncp7b, int nEncp7bLen, char* szSessionKey,
                    int nSessionKeyLen, char* szprikey,int nPrikeylen);

//更新证书
int LNCA_UpdateCert(char* szID, int iSignOrEnc,char* szp7b, int np7bLen);

//获取证书dn列表
/*
 参数：
 poutdnlist:外部分配的内存
 pnoutlistleng：返回结果的内存长度地址
 返回值：0成功，其它 错误
 说明：当poutdnlist为空时，*pnoutlistleng返回需要分配的内存长度大小
 */
int LNCA_GetCertList(char *poutdnlist,int *pnoutlistleng);

//根据ID获取证书
int LNCA_GetCertByID(char*szid,int iSignOrEnc,char*szoutcert,int *pnoutcertleng);

//根据ID获取申请书
int LNCA_GetReqByID(char*szid,int iSignOrEnc,char*szoutreq,int *pnoutreqleng);

//加密
int LNCA_Encrypt(unsigned char* szCert, int nCertLen, unsigned char* szData, int nDataLen, unsigned char* szEncData,
                 int* pnEncDataLen);

//解密
int LNCA_Decrypt(unsigned char* szCert, int nCertLen, unsigned char* szEncData, int nEncDataLen, unsigned char* szData,
                 int* pnDataLen);

//签名
int LNCA_Sign(unsigned char* szCert, int nCertLen, unsigned char* szData, int nDataLen, unsigned char* pszSign,
              int* pnSignLen);

//验签
int LNCA_VerifySign(unsigned char* szCert, int nCertLen, unsigned char* szData, int nDataLen, unsigned char* szSign,
                    int nSignLen);

//产生对称密钥
int LNCA_GenAESKey(unsigned char* szKey, int* pnKeyLen, unsigned char* szIV);

//对称加密
int LNCA_AESEncrypt(unsigned char* szKey, int nKeyLen, unsigned char* szIV, unsigned char* szData, int nDataLen,
                    unsigned char* pszEncData, int* pnEncDataLen);

//对称解密
int LNCA_AESDecrypt(unsigned char* szKey, int nKeyLen, unsigned char* szIV, unsigned char* szEncData, int nEncDataLen,
                    unsigned char* pszData, int* pnDataLen);

//pin码部分接口
int LNCA_UpdatePIN(char* szNewPin);
int LNCA_GetPIN(char* szoutpin);
int LNCA_CheckPIN(char *szpin);

//数据库文件是否存在
int LNCA_DBExist();

//获取证书数量
int LNCA_GetCertNum();

//清空证书
int LNCA_ClearCert();

/***************************************/
//so内部私有函数
int GetInfoFromID(unsigned char* szID ,STCERTINFO *pstcertinfo);
int GetInfoFromCryptCertID(unsigned char* szID ,STCERTINFO *pstcertinfo);
int GenReq(char* szDN,int itype,CMemSelfFree &msPrivKey, char * szReq, int* pnReqLen,CMemSelfFree &msb64hash,CMemSelfFree &msPubKey);
int GenReq_ECC(char* szDN,int itype,CMemSelfFree &msprikey, char * szReq, int* pnReqLen,CMemSelfFree &msb64hash,CMemSelfFree &msSM2PubKey);
int GetInfoFromCert(unsigned char* szCert, int nCertLen ,STCERTINFO *pstcertinfo);

#endif //_LNCA_CRYPT_H_
