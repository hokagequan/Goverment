#ifndef  _MEMSELFFREE_H_
#define _MEMSELFFREE_H_

class CMemSelfFree
{
public:
	int m_ileng;
	unsigned char*pbuf;

	CMemSelfFree(void);
	~CMemSelfFree(void);

	CMemSelfFree(int ileng);

	bool SetMemSize(int ilen);
};

#endif

