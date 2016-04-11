#ifndef  _SSLMEMSELFFREE_H_
#define _SSLMEMSELFFREE_H_
class CSSLMemSelfFree
{
public:
	int m_ileng;
	unsigned char*pbuf;

	CSSLMemSelfFree(void);
	~CSSLMemSelfFree(void);

	CSSLMemSelfFree(int ileng);

	bool SetMemSize(int ilen);
};

#endif

