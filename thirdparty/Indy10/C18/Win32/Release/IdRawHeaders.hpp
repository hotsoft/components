// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdRawHeaders.pas' rev: 25.00 (Windows)

#ifndef IdrawheadersHPP
#define IdrawheadersHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdStruct.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idrawheaders
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdSunB;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSunB : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	System::Byte Fs_b1;
	System::Byte Fs_b2;
	System::Byte Fs_b3;
	System::Byte Fs_b4;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property System::Byte s_b1 = {read=Fs_b1, write=Fs_b1, nodefault};
	__property System::Byte s_b2 = {read=Fs_b2, write=Fs_b2, nodefault};
	__property System::Byte s_b3 = {read=Fs_b3, write=Fs_b3, nodefault};
	__property System::Byte s_b4 = {read=Fs_b4, write=Fs_b4, nodefault};
public:
	/* TIdStruct.Create */ inline __fastcall virtual TIdSunB(void) : Idstruct::TIdStruct() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdSunB(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdSunW;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSunW : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	System::Word Fs_w1;
	System::Word Fs_w2;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property System::Word s_w1 = {read=Fs_w1, write=Fs_w1, nodefault};
	__property System::Word s_w2 = {read=Fs_w2, write=Fs_w2, nodefault};
public:
	/* TIdStruct.Create */ inline __fastcall virtual TIdSunW(void) : Idstruct::TIdStruct() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdSunW(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdInAddr;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdInAddr : public Idstruct::TIdLongWord
{
	typedef Idstruct::TIdLongWord inherited;
	
public:
	void __fastcall CopyFrom(TIdInAddr* const ASource);
public:
	/* TIdLongWord.Create */ inline __fastcall virtual TIdInAddr(void) : Idstruct::TIdLongWord() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdInAddr(void) { }
	
};

#pragma pack(pop)

typedef unsigned TIdNetTime;

class DELPHICLASS TIdICMPEcho;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdICMPEcho : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	System::Word Fid;
	System::Word Fseq;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property System::Word id = {read=Fid, write=Fid, nodefault};
	__property System::Word seq = {read=Fseq, write=Fseq, nodefault};
public:
	/* TIdStruct.Create */ inline __fastcall virtual TIdICMPEcho(void) : Idstruct::TIdStruct() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdICMPEcho(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdICMPFrag;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdICMPFrag : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	System::Word Fpad;
	System::Word Fmtu;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property System::Word pad = {read=Fpad, write=Fpad, nodefault};
	__property System::Word mtu = {read=Fmtu, write=Fmtu, nodefault};
public:
	/* TIdStruct.Create */ inline __fastcall virtual TIdICMPFrag(void) : Idstruct::TIdStruct() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdICMPFrag(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdICMPTs;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdICMPTs : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	unsigned Fotime;
	unsigned Frtime;
	unsigned Fttime;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property unsigned otime = {read=Fotime, write=Fotime, nodefault};
	__property unsigned rtime = {read=Frtime, write=Frtime, nodefault};
	__property unsigned ttime = {read=Fttime, write=Fttime, nodefault};
public:
	/* TIdStruct.Create */ inline __fastcall virtual TIdICMPTs(void) : Idstruct::TIdStruct() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdICMPTs(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdicmp_hun;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdicmp_hun : public Idstruct::TIdUnion
{
	typedef Idstruct::TIdUnion inherited;
	
protected:
	System::Word __fastcall Getecho_id(void);
	System::Word __fastcall Getecho_seq(void);
	System::Word __fastcall Getfrag_mtu(void);
	System::Word __fastcall Getfrag_pad(void);
	System::Byte __fastcall Getgateway_s_b1(void);
	System::Byte __fastcall Getgateway_s_b2(void);
	System::Byte __fastcall Getgateway_s_b3(void);
	System::Byte __fastcall Getgateway_s_b4(void);
	unsigned __fastcall Getgateway_s_l(void);
	System::Word __fastcall Getgateway_s_w1(void);
	System::Word __fastcall Getgateway_s_w2(void);
	void __fastcall Setecho_id(const System::Word Value);
	void __fastcall Setecho_seq(const System::Word Value);
	void __fastcall Setfrag_mtu(const System::Word Value);
	void __fastcall Setfrag_pad(const System::Word Value);
	void __fastcall Setgateway_s_b1(const System::Byte Value);
	void __fastcall Setgateway_s_b2(const System::Byte Value);
	void __fastcall Setgateway_s_b3(const System::Byte Value);
	void __fastcall Setgateway_s_b4(const System::Byte Value);
	void __fastcall Setgateway_s_l(const unsigned Value);
	void __fastcall Setgateway_s_w1(const System::Word Value);
	void __fastcall Setgateway_s_w2(const System::Word Value);
	
public:
	__fastcall virtual TIdicmp_hun(void);
	__property System::Word echo_id = {read=Getecho_id, write=Setecho_id, nodefault};
	__property System::Word echo_seq = {read=Getecho_seq, write=Setecho_seq, nodefault};
	__property System::Byte gateway_s_b1 = {read=Getgateway_s_b1, write=Setgateway_s_b1, nodefault};
	__property System::Byte gateway_s_b2 = {read=Getgateway_s_b2, write=Setgateway_s_b2, nodefault};
	__property System::Byte gateway_s_b3 = {read=Getgateway_s_b3, write=Setgateway_s_b3, nodefault};
	__property System::Byte gateway_s_b4 = {read=Getgateway_s_b4, write=Setgateway_s_b4, nodefault};
	__property System::Word gateway_s_w1 = {read=Getgateway_s_w1, write=Setgateway_s_w1, nodefault};
	__property System::Word gateway_s_w2 = {read=Getgateway_s_w2, write=Setgateway_s_w2, nodefault};
	__property unsigned gateway_s_l = {read=Getgateway_s_l, write=Setgateway_s_l, nodefault};
	__property System::Word frag_pad = {read=Getfrag_pad, write=Setfrag_pad, nodefault};
	__property System::Word frag_mtu = {read=Getfrag_mtu, write=Setfrag_mtu, nodefault};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdicmp_hun(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdicmp_dun;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdicmp_dun : public Idstruct::TIdUnion
{
	typedef Idstruct::TIdUnion inherited;
	
protected:
	System::Byte __fastcall Getdata(void);
	unsigned __fastcall Getmask(void);
	void __fastcall setdata(const System::Byte Value);
	void __fastcall Setmask(const unsigned Value);
	unsigned __fastcall Getts_otime(void);
	unsigned __fastcall Getts_rtime(void);
	unsigned __fastcall Getts_ttime(void);
	void __fastcall Setts_otime(const unsigned Value);
	void __fastcall Setts_rtime(const unsigned Value);
	void __fastcall Setts_ttime(const unsigned Value);
	
public:
	__fastcall virtual TIdicmp_dun(void);
	__property unsigned ts_otime = {read=Getts_otime, write=Setts_otime, nodefault};
	__property unsigned ts_rtime = {read=Getts_rtime, write=Setts_rtime, nodefault};
	__property unsigned ts_ttime = {read=Getts_ttime, write=Setts_ttime, nodefault};
	__property unsigned mask = {read=Getmask, write=Setmask, nodefault};
	__property System::Byte data = {read=Getdata, write=setdata, nodefault};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdicmp_dun(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdICMPHdr;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdICMPHdr : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	System::Byte Ficmp_type;
	System::Byte Ficmp_code;
	System::Word Ficmp_sum;
	TIdicmp_hun* Ficmp_hun;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	__fastcall virtual TIdICMPHdr(void);
	__fastcall virtual ~TIdICMPHdr(void);
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property System::Byte icmp_type = {read=Ficmp_type, write=Ficmp_type, nodefault};
	__property System::Byte icmp_code = {read=Ficmp_code, write=Ficmp_code, nodefault};
	__property System::Word icmp_sum = {read=Ficmp_sum, write=Ficmp_sum, nodefault};
	__property TIdicmp_hun* icmp_hun = {read=Ficmp_hun};
};

#pragma pack(pop)

class DELPHICLASS TIdicmp6_un;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdicmp6_un : public Idstruct::TIdUnion
{
	typedef Idstruct::TIdUnion inherited;
	
protected:
	System::Word __fastcall Geticmp6_data16(void);
	System::Byte __fastcall Geticmp6_data8(void);
	void __fastcall Seticmp6_data16(const System::Word Value);
	void __fastcall Seticmp6_data8(const System::Byte Value);
	System::Word __fastcall Geticmp6_seq(void);
	void __fastcall Seticmp6_seq(const System::Word Value);
	System::Word __fastcall Geticmp6_un_data16(int Index);
	unsigned __fastcall Geticmp6_un_data32(void);
	System::Byte __fastcall Geticmp6_un_data8(int Index);
	void __fastcall Seticmp6_un_data16(int Index, const System::Word Value);
	void __fastcall Seticmp6_un_data32(const unsigned Value);
	void __fastcall Seticmp6_un_data8(int Index, const System::Byte Value);
	
public:
	__fastcall virtual TIdicmp6_un(void);
	__property unsigned icmp6_un_data32 = {read=Geticmp6_un_data32, write=Seticmp6_un_data32, nodefault};
	__property System::Word icmp6_un_data16[int Index] = {read=Geticmp6_un_data16, write=Seticmp6_un_data16};
	__property System::Byte icmp6_un_data8[int Index] = {read=Geticmp6_un_data8, write=Seticmp6_un_data8};
	__property unsigned icmp6_data32 = {read=Geticmp6_un_data32, write=Seticmp6_un_data32, nodefault};
	__property System::Word icmp6_data16 = {read=Geticmp6_data16, write=Seticmp6_data16, nodefault};
	__property System::Byte icmp6_data8 = {read=Geticmp6_data8, write=Seticmp6_data8, nodefault};
	__property unsigned icmp6_pptr = {read=Geticmp6_un_data32, write=Seticmp6_un_data32, nodefault};
	__property unsigned icmp6_mtu = {read=Geticmp6_un_data32, write=Seticmp6_un_data32, nodefault};
	__property System::Word icmp6_id = {read=Geticmp6_data16, write=Seticmp6_data16, nodefault};
	__property System::Word icmp6_seq = {read=Geticmp6_seq, write=Seticmp6_seq, nodefault};
	__property System::Word icmp6_maxdelay = {read=Geticmp6_data16, write=Seticmp6_data16, nodefault};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdicmp6_un(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdicmp6_hdr;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdicmp6_hdr : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	System::Byte Ficmp6_type;
	System::Byte FIcmp6_code;
	System::Word Ficmp6_cksum;
	TIdicmp6_un* Fdata;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	__fastcall virtual TIdicmp6_hdr(void);
	__fastcall virtual ~TIdicmp6_hdr(void);
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property System::Byte icmp6_type = {read=Ficmp6_type, write=Ficmp6_type, nodefault};
	__property System::Byte icmp6_code = {read=FIcmp6_code, write=FIcmp6_code, nodefault};
	__property System::Word icmp6_cksum = {read=Ficmp6_cksum, write=Ficmp6_cksum, nodefault};
	__property TIdicmp6_un* data = {read=Fdata};
};

#pragma pack(pop)

class DELPHICLASS TIdIPOptions;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdIPOptions : public Idstruct::TIdUnion
{
	typedef Idstruct::TIdUnion inherited;
	
public:
	System::Byte operator[](int Index) { return ipopt_list[Index]; }
	
public:
	__fastcall virtual TIdIPOptions(void);
	System::Byte __fastcall get_ipopt_list(int Index);
	void __fastcall set_ipopt_list(int Index, const System::Byte Value);
	__property System::Byte ipopt_list[int Index] = {read=get_ipopt_list, write=set_ipopt_list/*, default*/};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdIPOptions(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdIPHdr;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdIPHdr : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	System::Byte Fip_verlen;
	System::Byte Fip_tos;
	System::Word Fip_len;
	System::Word Fip_id;
	System::Word Fip_off;
	System::Byte Fip_ttl;
	System::Byte Fip_p;
	System::Word Fip_sum;
	TIdInAddr* Fip_src;
	TIdInAddr* Fip_dst;
	unsigned Fip_options;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	__fastcall virtual TIdIPHdr(void);
	__fastcall virtual ~TIdIPHdr(void);
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	void __fastcall CopyFrom(TIdIPHdr* const ASource);
	__property System::Byte ip_verlen = {read=Fip_verlen, write=Fip_verlen, nodefault};
	__property System::Byte ip_tos = {read=Fip_tos, write=Fip_tos, nodefault};
	__property System::Word ip_len = {read=Fip_len, write=Fip_len, nodefault};
	__property System::Word ip_id = {read=Fip_id, write=Fip_id, nodefault};
	__property System::Word ip_off = {read=Fip_off, write=Fip_off, nodefault};
	__property System::Byte ip_ttl = {read=Fip_ttl, write=Fip_ttl, nodefault};
	__property System::Byte ip_p = {read=Fip_p, write=Fip_p, nodefault};
	__property System::Word ip_sum = {read=Fip_sum, write=Fip_sum, nodefault};
	__property TIdInAddr* ip_src = {read=Fip_src};
	__property TIdInAddr* ip_dst = {read=Fip_dst};
	__property unsigned ip_options = {read=Fip_options, write=Fip_options, nodefault};
};

#pragma pack(pop)

class DELPHICLASS TIdTCPOptions;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdTCPOptions : public Idstruct::TIdUnion
{
	typedef Idstruct::TIdUnion inherited;
	
public:
	System::Byte operator[](int Index) { return tcpopt_list[Index]; }
	
public:
	__fastcall virtual TIdTCPOptions(void);
	System::Byte __fastcall gettcpopt_list(int Index);
	void __fastcall settcpopt_list(int Index, const System::Byte Value);
	__property System::Byte tcpopt_list[int Index] = {read=gettcpopt_list, write=settcpopt_list/*, default*/};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdTCPOptions(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdTCPHdr;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdTCPHdr : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	System::Word Ftcp_sport;
	System::Word Ftcp_dport;
	unsigned Ftcp_seq;
	unsigned Ftcp_ack;
	System::Byte Ftcp_x2off;
	System::Byte Ftcp_flags;
	System::Word Ftcp_win;
	System::Word Ftcp_sum;
	System::Word Ftcp_urp;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property System::Word tcp_sport = {read=Ftcp_sport, write=Ftcp_sport, nodefault};
	__property System::Word tcp_dport = {read=Ftcp_dport, write=Ftcp_dport, nodefault};
	__property unsigned tcp_seq = {read=Ftcp_seq, write=Ftcp_seq, nodefault};
	__property unsigned tcp_ack = {read=Ftcp_ack, write=Ftcp_ack, nodefault};
	__property System::Byte tcp_x2off = {read=Ftcp_x2off, write=Ftcp_x2off, nodefault};
	__property System::Byte tcp_flags = {read=Ftcp_flags, write=Ftcp_flags, nodefault};
	__property System::Word tcp_win = {read=Ftcp_win, write=Ftcp_win, nodefault};
	__property System::Word tcp_sum = {read=Ftcp_sum, write=Ftcp_sum, nodefault};
	__property System::Word tcp_urp = {read=Ftcp_urp, write=Ftcp_urp, nodefault};
public:
	/* TIdStruct.Create */ inline __fastcall virtual TIdTCPHdr(void) : Idstruct::TIdStruct() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdTCPHdr(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdUDPHdr;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdUDPHdr : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	System::Word Fudp_sport;
	System::Word Fudp_dport;
	System::Word Fudp_ulen;
	System::Word Fudp_sum;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property System::Word udp_sport = {read=Fudp_sport, write=Fudp_sport, nodefault};
	__property System::Word udp_dport = {read=Fudp_dport, write=Fudp_dport, nodefault};
	__property System::Word udp_ulen = {read=Fudp_ulen, write=Fudp_ulen, nodefault};
	__property System::Word udp_sum = {read=Fudp_sum, write=Fudp_sum, nodefault};
public:
	/* TIdStruct.Create */ inline __fastcall virtual TIdUDPHdr(void) : Idstruct::TIdStruct() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdUDPHdr(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdIGMPHdr;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdIGMPHdr : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	System::Byte Figmp_type;
	System::Byte Figmp_code;
	System::Word Figmp_sum;
	TIdInAddr* Figmp_group;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	__fastcall virtual TIdIGMPHdr(void);
	__fastcall virtual ~TIdIGMPHdr(void);
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property System::Byte igmp_type = {read=Figmp_type, write=Figmp_type, nodefault};
	__property System::Byte igmp_code = {read=Figmp_code, write=Figmp_code, nodefault};
	__property System::Word igmp_sum = {read=Figmp_sum, write=Figmp_sum, nodefault};
	__property TIdInAddr* igmp_group = {read=Figmp_group};
};

#pragma pack(pop)

class DELPHICLASS TIdEtherAddr;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdEtherAddr : public Idstruct::TIdUnion
{
	typedef Idstruct::TIdUnion inherited;
	
public:
	System::Byte operator[](int Index) { return ether_addr_octet[Index]; }
	
public:
	__fastcall virtual TIdEtherAddr(void);
	void __fastcall CopyFrom(TIdEtherAddr* const ASource);
	void __fastcall SetData(const Idglobal::TIdBytes Value);
	System::Byte __fastcall getether_addr_octet(int Index);
	void __fastcall setether_addr_octet(int Index, const System::Byte Value);
	__property System::Byte ether_addr_octet[int Index] = {read=getether_addr_octet, write=setether_addr_octet/*, default*/};
	__property Idglobal::TIdBytes Data = {read=FBuffer, write=SetData};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdEtherAddr(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdEthernetHdr;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdEthernetHdr : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	TIdEtherAddr* Fether_dhost;
	TIdEtherAddr* Fether_shost;
	System::Word Fether_type;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	__fastcall virtual TIdEthernetHdr(void);
	__fastcall virtual ~TIdEthernetHdr(void);
	void __fastcall CopyFrom(TIdEthernetHdr* const ASource);
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property TIdEtherAddr* ether_dhost = {read=Fether_dhost};
	__property TIdEtherAddr* ether_shost = {read=Fether_shost};
	__property System::Word ether_type = {read=Fether_type, write=Fether_type, nodefault};
};

#pragma pack(pop)

class DELPHICLASS TIdARPHdr;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdARPHdr : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	System::Word Farp_hrd;
	System::Word Farp_pro;
	System::Byte Farp_hln;
	System::Byte Farp_pln;
	System::Word Farp_op;
	TIdEtherAddr* Farp_sha;
	TIdInAddr* Farp_spa;
	TIdEtherAddr* Farp_tha;
	TIdInAddr* Farp_tpa;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	__fastcall virtual TIdARPHdr(void);
	__fastcall virtual ~TIdARPHdr(void);
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property System::Word arp_hrd = {read=Farp_hrd, write=Farp_hrd, nodefault};
	__property System::Word arp_pro = {read=Farp_pro, write=Farp_pro, nodefault};
	__property System::Byte arp_hln = {read=Farp_hln, write=Farp_hln, nodefault};
	__property System::Byte arp_pln = {read=Farp_pln, write=Farp_pln, nodefault};
	__property System::Word arp_op = {read=Farp_op, write=Farp_op, nodefault};
	__property TIdEtherAddr* arp_sha = {read=Farp_sha};
	__property TIdInAddr* arp_spa = {read=Farp_spa};
	__property TIdEtherAddr* arp_tha = {read=Farp_tha};
	__property TIdInAddr* arp_tpa = {read=Farp_tpa};
};

#pragma pack(pop)

class DELPHICLASS TIdDNSHdr;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdDNSHdr : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	System::Word Fdns_id;
	System::Word Fdns_flags;
	System::Word Fdns_num_q;
	System::Word Fdns_num_answ_rr;
	System::Word Fdns_num_auth_rr;
	System::Word Fdns_num_addi_rr;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property System::Word dns_id = {read=Fdns_id, write=Fdns_id, nodefault};
	__property System::Word dns_flags = {read=Fdns_flags, write=Fdns_flags, nodefault};
	__property System::Word dns_num_q = {read=Fdns_num_q, write=Fdns_num_q, nodefault};
	__property System::Word dns_num_answ_rr = {read=Fdns_num_answ_rr, write=Fdns_num_answ_rr, nodefault};
	__property System::Word dns_num_auth_rr = {read=Fdns_num_auth_rr, write=Fdns_num_auth_rr, nodefault};
	__property System::Word dns_num_addi_rr = {read=Fdns_num_addi_rr, write=Fdns_num_addi_rr, nodefault};
public:
	/* TIdStruct.Create */ inline __fastcall virtual TIdDNSHdr(void) : Idstruct::TIdStruct() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdDNSHdr(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdRIPHdr;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdRIPHdr : public Idstruct::TIdStruct
{
	typedef Idstruct::TIdStruct inherited;
	
protected:
	System::Byte Frip_cmd;
	System::Byte Frip_ver;
	System::Word Frip_rd;
	System::Word Frip_af;
	System::Word Frip_rt;
	unsigned Frip_addr;
	unsigned Frip_mask;
	unsigned Frip_next_hop;
	unsigned Frip_metric;
	virtual unsigned __fastcall GetBytesLen(void);
	
public:
	virtual void __fastcall ReadStruct(const Idglobal::TIdBytes ABytes, unsigned &VIndex);
	virtual void __fastcall WriteStruct(Idglobal::TIdBytes &VBytes, unsigned &VIndex);
	__property System::Byte rip_cmd = {read=Frip_cmd, write=Frip_cmd, nodefault};
	__property System::Byte rip_ver = {read=Frip_ver, write=Frip_ver, nodefault};
	__property System::Word rip_rd = {read=Frip_rd, write=Frip_rd, nodefault};
	__property System::Word rip_af = {read=Frip_af, write=Frip_af, nodefault};
	__property System::Word rip_rt = {read=Frip_rt, write=Frip_rt, nodefault};
	__property unsigned rip_addr = {read=Frip_addr, write=Frip_addr, nodefault};
	__property unsigned rip_mask = {read=Frip_mask, write=Frip_mask, nodefault};
	__property unsigned rip_next_hop = {read=Frip_next_hop, write=Frip_next_hop, nodefault};
	__property unsigned rip_metric = {read=Frip_metric, write=Frip_metric, nodefault};
public:
	/* TIdStruct.Create */ inline __fastcall virtual TIdRIPHdr(void) : Idstruct::TIdStruct() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdRIPHdr(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 Id_ARP_HSIZE = System::Int8(0x1c);
static const System::Int8 Id_DNS_HSIZE = System::Int8(0xc);
static const System::Int8 Id_ETH_HSIZE = System::Int8(0xe);
static const System::Int8 Id_ICMP_HSIZE = System::Int8(0x4);
static const System::Int8 Id_ICMP_ECHO_HSIZE = System::Int8(0x8);
static const System::Int8 Id_ICMP6_ECHO_HSIZE = System::Int8(0x8);
static const System::Int8 Id_ICMP_MASK_HSIZE = System::Int8(0xc);
static const System::Int8 Id_ICMP_UNREACH_HSIZE = System::Int8(0x8);
static const System::Int8 Id_ICMP_TIMEXCEED_HSIZE = System::Int8(0x8);
static const System::Int8 Id_ICMP_REDIRECT_HSIZE = System::Int8(0x8);
static const System::Int8 Id_ICMP_TS_HSIZE = System::Int8(0x14);
static const System::Int8 Id_IGMP_HSIZE = System::Int8(0x8);
static const System::Int8 Id_IP_HSIZE = System::Int8(0x14);
static const System::Int8 Id_IPv6_HSIZE = System::Int8(0x28);
static const System::Int8 Id_RIP_HSIZE = System::Int8(0x18);
static const System::Int8 Id_TCP_HSIZE = System::Int8(0x14);
static const System::Int8 Id_UDP_HSIZE = System::Int8(0x8);
static const System::Word Id_IP_RF = System::Word(0x8000);
static const System::Word Id_IP_DF = System::Word(0x4000);
static const System::Word Id_IP_MF = System::Word(0x2000);
static const System::Word Id_IP_OFFMASK = System::Word(0x1fff);
static const System::Int8 Id_TCP_FIN = System::Int8(0x1);
static const System::Int8 Id_TCP_SYN = System::Int8(0x2);
static const System::Int8 Id_TCP_RST = System::Int8(0x4);
static const System::Int8 Id_TCP_PUSH = System::Int8(0x8);
static const System::Int8 Id_TCP_ACK = System::Int8(0x10);
static const System::Int8 Id_TCP_URG = System::Int8(0x20);
static const System::Int8 Id_ICMP_ECHOREPLY = System::Int8(0x0);
static const System::Int8 Id_ICMP_UNREACH = System::Int8(0x3);
static const System::Int8 Id_ICMP_SOURCEQUENCH = System::Int8(0x4);
static const System::Int8 Id_ICMP_REDIRECT = System::Int8(0x5);
static const System::Int8 Id_ICMP_ECHO = System::Int8(0x8);
static const System::Int8 Id_ICMP_ROUTERADVERT = System::Int8(0x9);
static const System::Int8 Id_ICMP_ROUTERSOLICIT = System::Int8(0xa);
static const System::Int8 Id_ICMP_TIMXCEED = System::Int8(0xb);
static const System::Int8 Id_ICMP_PARAMPROB = System::Int8(0xc);
static const System::Int8 Id_ICMP_TSTAMP = System::Int8(0xd);
static const System::Int8 Id_ICMP_TSTAMPREPLY = System::Int8(0xe);
static const System::Int8 Id_ICMP_IREQ = System::Int8(0xf);
static const System::Int8 Id_ICMP_IREQREPLY = System::Int8(0x10);
static const System::Int8 Id_ICMP_MASKREQ = System::Int8(0x11);
static const System::Int8 Id_ICMP_MASKREPLY = System::Int8(0x12);
static const System::Int8 Id_ICMP_TRACEROUTE = System::Int8(0x1e);
static const System::Int8 Id_ICMP_DATAGRAM_CONV = System::Int8(0x1f);
static const System::Int8 Id_ICMP_MOB_HOST_REDIR = System::Int8(0x20);
static const System::Int8 Id_ICMP_IPv6_WHERE_ARE_YOU = System::Int8(0x21);
static const System::Int8 Id_ICMP_IPv6_I_AM_HERE = System::Int8(0x22);
static const System::Int8 Id_ICMP_MOB_REG_REQ = System::Int8(0x23);
static const System::Int8 Id_ICMP_MOB_REG_REPLY = System::Int8(0x24);
static const System::Int8 Id_ICMP_SKIP = System::Int8(0x27);
static const System::Int8 Id_ICMP_PHOTURIS = System::Int8(0x28);
static const System::Int8 Id_ICMP_UNREACH_NET = System::Int8(0x0);
static const System::Int8 Id_ICMP_UNREACH_HOST = System::Int8(0x1);
static const System::Int8 Id_ICMP_UNREACH_PROTOCOL = System::Int8(0x2);
static const System::Int8 Id_ICMP_UNREACH_PORT = System::Int8(0x3);
static const System::Int8 Id_ICMP_UNREACH_NEEDFRAG = System::Int8(0x4);
static const System::Int8 Id_ICMP_UNREACH_SRCFAIL = System::Int8(0x5);
static const System::Int8 Id_ICMP_UNREACH_NET_UNKNOWN = System::Int8(0x6);
static const System::Int8 Id_ICMP_UNREACH_HOST_UNKNOWN = System::Int8(0x7);
static const System::Int8 Id_ICMP_UNREACH_ISOLATED = System::Int8(0x8);
static const System::Int8 Id_ICMP_UNREACH_NET_PROHIB = System::Int8(0x9);
static const System::Int8 Id_ICMP_UNREACH_HOST_PROHIB = System::Int8(0xa);
static const System::Int8 Id_ICMP_UNREACH_TOSNET = System::Int8(0xb);
static const System::Int8 Id_ICMP_UNREACH_TOSHOST = System::Int8(0xc);
static const System::Int8 Id_ICMP_UNREACH_FILTER_PROHIB = System::Int8(0xd);
static const System::Int8 Id_ICMP_UNREACH_HOST_PRECEDENCE = System::Int8(0xe);
static const System::Int8 Id_ICMP_UNREACH_PRECEDENCE_CUTOFF = System::Int8(0xf);
static const System::Int8 Id_ICMP_REDIRECT_NET = System::Int8(0x0);
static const System::Int8 Id_ICMP_REDIRECT_HOST = System::Int8(0x1);
static const System::Int8 Id_ICMP_REDIRECT_TOSNET = System::Int8(0x2);
static const System::Int8 Id_ICMP_REDIRECT_TOSHOST = System::Int8(0x3);
static const System::Int8 Id_ICMP_TIMXCEED_INTRANS = System::Int8(0x0);
static const System::Int8 Id_ICMP_TIMXCEED_REASS = System::Int8(0x1);
static const System::Int8 Id_ICMP_PARAMPROB_OPTABSENT = System::Int8(0x1);
static const System::Int8 Id_ICMP_TRACEROUTE_PACKET_FORWARDED = System::Int8(0x0);
static const System::Int8 Id_ICMP_TRACEROUTE_NO_ROUTE = System::Int8(0x1);
static const System::Int8 Id_ICMP_BAD_SPI = System::Int8(0x0);
static const System::Int8 Id_ICMP_AUTH_FAILED = System::Int8(0x1);
static const System::Int8 Id_ICMP_DECOMPRESS_FAILED = System::Int8(0x2);
static const System::Int8 Id_ICMP_DECRYPTION_FAILED = System::Int8(0x3);
static const System::Int8 Id_ICMP_NEED_AUTHENTICATION = System::Int8(0x4);
static const System::Int8 Id_ICMP_NEED_AUTHORIZATION = System::Int8(0x5);
static const System::Int8 Id_ICMP_CONV_UNSPEC = System::Int8(0x0);
static const System::Int8 Id_ICMP_CONV_DONTCONV_OPTION = System::Int8(0x1);
static const System::Int8 Id_ICMP_CONV_UNKNOWN_MAN_OPTION = System::Int8(0x2);
static const System::Int8 Id_ICMP_CONV_UNKNWON_UNSEP_OPTION = System::Int8(0x3);
static const System::Int8 Id_ICMP_CONV_UNSEP_TRANSPORT = System::Int8(0x4);
static const System::Int8 Id_ICMP_CONV_OVERALL_LENGTH_EXCEEDED = System::Int8(0x5);
static const System::Int8 Id_ICMP_CONV_IP_HEADER_LEN_EXCEEDED = System::Int8(0x6);
static const System::Int8 Id_ICMP_CONV_TRANS_PROT_255 = System::Int8(0x7);
static const System::Int8 Id_ICMP_CONV_PORT_OUT_OF_RANGE = System::Int8(0x8);
static const System::Int8 Id_ICMP_CONV_TRANS_HEADER_LEN_EXCEEDED = System::Int8(0x9);
static const System::Int8 Id_ICMP_CONV_32BIT_ROLLOVER_AND_ACK = System::Int8(0xa);
static const System::Int8 Id_ICMP_CONV_UNKNOWN_MAN_TRANS_OPTION = System::Int8(0xb);
static const System::Int8 ICMP_MIN = System::Int8(0x8);
static const System::Int8 ICMP6_DST_UNREACH = System::Int8(0x1);
static const System::Int8 ICMP6_PACKET_TOO_BIG = System::Int8(0x2);
static const System::Int8 ICMP6_TIME_EXCEEDED = System::Int8(0x3);
static const System::Int8 ICMP6_PARAM_PROB = System::Int8(0x4);
static const System::Byte ICMP6_INFOMSG_MASK = System::Byte(0x80);
static const System::Byte ICMP6_ECHO_REQUEST = System::Byte(0x80);
static const System::Byte ICMP6_ECHO_REPLY = System::Byte(0x81);
static const System::Byte ICMP6_MEMBERSHIP_QUERY = System::Byte(0x82);
static const System::Byte ICMP6_MEMBERSHIP_REPORT = System::Byte(0x83);
static const System::Byte ICMP6_MEMBERSHIP_REDUCTION = System::Byte(0x84);
static const System::Int8 ICMP6_DST_UNREACH_NOROUTE = System::Int8(0x0);
static const System::Int8 ICMP6_DST_UNREACH_ADMIN = System::Int8(0x1);
static const System::Int8 ICMP6_DST_UNREACH_NOTNEIGHBOR = System::Int8(0x2);
static const System::Int8 ICMP6_DST_UNREACH_ADDR = System::Int8(0x3);
static const System::Int8 ICMP6_DST_UNREACH_NOPORT = System::Int8(0x4);
static const System::Int8 ICMP6_DST_UNREACH_SOURCE_FILTERING = System::Int8(0x5);
static const System::Int8 ICMP6_DST_UNREACH_REJCT_DST = System::Int8(0x6);
static const System::Int8 ICMP6_TIME_EXCEED_TRANSIT = System::Int8(0x0);
static const System::Int8 ICMP6_TIME_EXCEED_REASSEMBLY = System::Int8(0x1);
static const System::Int8 ICMP6_PARAMPROB_HEADER = System::Int8(0x0);
static const System::Int8 ICMP6_PARAMPROB_NEXTHEADER = System::Int8(0x1);
static const System::Int8 ICMP6_PARAMPROB_OPTION = System::Int8(0x2);
static const System::Byte ND_ROUTER_SOLICIT = System::Byte(0x85);
static const System::Byte ND_ROUTER_ADVERT = System::Byte(0x86);
static const System::Byte ND_NEIGHBOR_SOLICIT = System::Byte(0x87);
static const System::Byte ND_NEIGHBOR_ADVERT = System::Byte(0x88);
static const System::Byte ND_REDIRECT = System::Byte(0x89);
static const System::Int8 Id_IGMP_MEMBERSHIP_QUERY = System::Int8(0x11);
static const System::Int8 Id_IGMP_V1_MEMBERSHIP_REPORT = System::Int8(0x12);
static const System::Int8 Id_IGMP_V2_MEMBERSHIP_REPORT = System::Int8(0x16);
static const System::Int8 Id_IGMP_LEAVE_GROUP = System::Int8(0x17);
static const System::Word Id_ETHERTYPE_PUP = System::Word(0x200);
static const System::Word Id_ETHERTYPE_IP = System::Word(0x800);
static const System::Word Id_ETHERTYPE_ARP = System::Word(0x806);
static const System::Word Id_ETHERTYPE_REVARP = System::Word(0x8035);
static const System::Word Id_ETHERTYPE_VLAN = System::Word(0x8100);
static const System::Word Id_ETHERTYPE_LOOPBACK = System::Word(0x9000);
static const System::Int8 Id_ARPHRD_ETHER = System::Int8(0x1);
static const System::Int8 Id_ARPOP_REQUEST = System::Int8(0x1);
static const System::Int8 Id_ARPOP_REPLY = System::Int8(0x2);
static const System::Int8 Id_ARPOP_REVREQUEST = System::Int8(0x3);
static const System::Int8 Id_ARPOP_REVREPLY = System::Int8(0x4);
static const System::Int8 Id_ARPOP_INVREQUEST = System::Int8(0x8);
static const System::Int8 Id_ARPOP_INVREPLY = System::Int8(0x9);
static const System::Int8 Id_RIPCMD_REQUEST = System::Int8(0x1);
static const System::Int8 Id_RIPCMD_RESPONSE = System::Int8(0x2);
static const System::Int8 Id_RIPCMD_TRACEON = System::Int8(0x3);
static const System::Int8 Id_RIPCMD_TRACEOFF = System::Int8(0x4);
static const System::Int8 Id_RIPCMD_POLL = System::Int8(0x5);
static const System::Int8 Id_RIPCMD_POLLENTRY = System::Int8(0x6);
static const System::Int8 Id_RIPCMD_MAX = System::Int8(0x7);
static const System::Int8 Id_RIPVER_0 = System::Int8(0x0);
static const System::Int8 Id_RIPVER_1 = System::Int8(0x1);
static const System::Int8 Id_RIPVER_2 = System::Int8(0x2);
static const System::Int8 Id_MAX_IPOPTLEN = System::Int8(0x28);
static const System::Word Id_IP_MAXPACKET = System::Word(0xffff);
static const System::Int8 Id_ETHER_ADDR_LEN = System::Int8(0x6);
}	/* namespace Idrawheaders */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDRAWHEADERS)
using namespace Idrawheaders;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdrawheadersHPP
