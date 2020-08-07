// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdStackConsts.pas' rev: 25.00 (Windows)

#ifndef IdstackconstsHPP
#define IdstackconstsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdWship6.hpp>	// Pascal unit
#include <IdWinsock2.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idstackconsts
{
//-- type declarations -------------------------------------------------------
typedef NativeUInt TIdStackSocketHandle;

typedef int TIdSocketType;

typedef int TIdSocketProtocol;

typedef int TIdSocketOption;

typedef int TIdSocketOptionLevel;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE int Id_SO_True;
extern DELPHI_PACKAGE int Id_SO_False;
static const System::Int8 Id_IPV6_HDRINCL = System::Int8(0x2);
static const System::Int8 Id_IPV6_UNICAST_HOPS = System::Int8(0x4);
static const System::Int8 Id_IPV6_MULTICAST_IF = System::Int8(0x9);
static const System::Int8 Id_IPV6_MULTICAST_HOPS = System::Int8(0xa);
static const System::Int8 Id_IPV6_MULTICAST_LOOP = System::Int8(0xb);
static const System::Int8 Id_IPV6_ADD_MEMBERSHIP = System::Int8(0xc);
static const System::Int8 Id_IPV6_DROP_MEMBERSHIP = System::Int8(0xd);
static const System::Int8 Id_IPV6_PKTINFO = System::Int8(0x13);
static const System::Int8 Id_IPV6_HOPLIMIT = System::Int8(0x15);
static const System::Int8 Id_IP_MULTICAST_TTL = System::Int8(0xa);
static const System::Int8 Id_IP_MULTICAST_LOOP = System::Int8(0xb);
static const System::Int8 Id_IP_ADD_MEMBERSHIP = System::Int8(0xc);
static const System::Int8 Id_IP_DROP_MEMBERSHIP = System::Int8(0xd);
static const System::Int8 Id_IP_HDR_INCLUDED = System::Int8(0x2);
static const System::Int8 Id_PF_INET4 = System::Int8(0x2);
static const System::Int8 Id_PF_INET6 = System::Int8(0x17);
static const int Id_SOCK_UNKNOWN = int(0);
static const int Id_SOCK_STREAM = int(1);
static const int Id_SOCK_DGRAM = int(2);
static const int Id_SOCK_RAW = int(3);
static const int Id_SOCK_RDM = int(4);
static const System::Int8 Id_SOCK_SEQPACKET = System::Int8(0x5);
static const System::Int8 Id_IPPROTO_GGP = System::Int8(0x3);
static const System::Int8 Id_IPPROTO_ICMP = System::Int8(0x1);
static const System::Int8 Id_IPPROTO_ICMPV6 = System::Int8(0x3a);
static const System::Int8 Id_IPPROTO_IDP = System::Int8(0x16);
static const System::Int8 Id_IPPROTO_IGMP = System::Int8(0x2);
static const System::Int8 Id_IPPROTO_IP = System::Int8(0x0);
static const System::Int8 Id_IPPROTO_IPv6 = System::Int8(0x29);
static const System::Int8 Id_IPPROTO_ND = System::Int8(0x4d);
static const System::Int8 Id_IPPROTO_PUP = System::Int8(0xc);
static const System::Byte Id_IPPROTO_RAW = System::Byte(0xff);
static const System::Int8 Id_IPPROTO_TCP = System::Int8(0x6);
static const System::Int8 Id_IPPROTO_UDP = System::Int8(0x11);
static const System::Word Id_IPPROTO_MAX = System::Word(0x100);
static const System::Word Id_SOL_SOCKET = System::Word(0xffff);
static const System::Int8 Id_SOL_IP = System::Int8(0x0);
static const System::Int8 Id_SOL_IPv6 = System::Int8(0x29);
static const System::Int8 Id_SOL_TCP = System::Int8(0x6);
static const System::Int8 Id_SOL_UDP = System::Int8(0x11);
static const System::Int8 Id_SO_BROADCAST = System::Int8(0x20);
static const System::Int8 Id_SO_DEBUG = System::Int8(0x1);
static const short Id_SO_DONTLINGER = short(-129);
static const System::Int8 Id_SO_DONTROUTE = System::Int8(0x10);
static const System::Word Id_SO_ERROR = System::Word(0x1007);
static const System::Int8 Id_SO_KEEPALIVE = System::Int8(0x8);
static const System::Byte Id_SO_LINGER = System::Byte(0x80);
static const System::Word Id_SO_OOBINLINE = System::Word(0x100);
static const System::Word Id_SO_RCVBUF = System::Word(0x1002);
static const System::Int8 Id_SO_REUSEADDR = System::Int8(0x4);
static const System::Word Id_SO_SNDBUF = System::Word(0x1001);
static const System::Word Id_SO_TYPE = System::Word(0x1008);
static const System::Word Id_SO_UPDATE_ACCEPT_CONTEXT = System::Word(0x700b);
static const System::Word Id_SO_UPDATE_CONNECT_CONTEXT = System::Word(0x7010);
static const System::Word Id_SO_RCVTIMEO = System::Word(0x1006);
static const System::Word Id_SO_SNDTIMEO = System::Word(0x1005);
static const System::Int8 Id_SO_IP_TTL = System::Int8(0x4);
static const System::Int8 Id_INADDR_ANY = System::Int8(0x0);
static const unsigned Id_INADDR_NONE = unsigned(0xffffffff);
static const System::Int8 Id_TCP_NODELAY = System::Int8(0x1);
static const unsigned Id_INVALID_SOCKET = unsigned(0xffffffff);
static const System::Int8 Id_SOCKET_ERROR = System::Int8(-1);
static const System::Int8 Id_SOCKETOPTIONLEVEL_TCP = System::Int8(0x6);
static const System::Int8 Id_SD_Recv = System::Int8(0x0);
static const System::Int8 Id_SD_Send = System::Int8(0x1);
static const System::Int8 Id_SD_Both = System::Int8(0x2);
static const System::Word Id_WSAEINTR = System::Word(0x2714);
static const System::Word Id_WSAEBADF = System::Word(0x2719);
static const System::Word Id_WSAEACCES = System::Word(0x271d);
static const System::Word Id_WSAEFAULT = System::Word(0x271e);
static const System::Word Id_WSAEINVAL = System::Word(0x2726);
static const System::Word Id_WSAEMFILE = System::Word(0x2728);
static const System::Word Id_WSAEWOULDBLOCK = System::Word(0x2733);
static const System::Word Id_WSAEINPROGRESS = System::Word(0x2734);
static const System::Word Id_WSAEALREADY = System::Word(0x2735);
static const System::Word Id_WSAENOTSOCK = System::Word(0x2736);
static const System::Word Id_WSAEDESTADDRREQ = System::Word(0x2737);
static const System::Word Id_WSAEMSGSIZE = System::Word(0x2738);
static const System::Word Id_WSAEPROTOTYPE = System::Word(0x2739);
static const System::Word Id_WSAENOPROTOOPT = System::Word(0x273a);
static const System::Word Id_WSAEPROTONOSUPPORT = System::Word(0x273b);
static const System::Word Id_WSAESOCKTNOSUPPORT = System::Word(0x273c);
static const System::Word Id_WSAEOPNOTSUPP = System::Word(0x273d);
static const System::Word Id_WSAEPFNOSUPPORT = System::Word(0x273e);
static const System::Word Id_WSAEAFNOSUPPORT = System::Word(0x273f);
static const System::Word Id_WSAEADDRINUSE = System::Word(0x2740);
static const System::Word Id_WSAEADDRNOTAVAIL = System::Word(0x2741);
static const System::Word Id_WSAENETDOWN = System::Word(0x2742);
static const System::Word Id_WSAENETUNREACH = System::Word(0x2743);
static const System::Word Id_WSAENETRESET = System::Word(0x2744);
static const System::Word Id_WSAECONNABORTED = System::Word(0x2745);
static const System::Word Id_WSAECONNRESET = System::Word(0x2746);
static const System::Word Id_WSAENOBUFS = System::Word(0x2747);
static const System::Word Id_WSAEISCONN = System::Word(0x2748);
static const System::Word Id_WSAENOTCONN = System::Word(0x2749);
static const System::Word Id_WSAESHUTDOWN = System::Word(0x274a);
static const System::Word Id_WSAETOOMANYREFS = System::Word(0x274b);
static const System::Word Id_WSAETIMEDOUT = System::Word(0x274c);
static const System::Word Id_WSAECONNREFUSED = System::Word(0x274d);
static const System::Word Id_WSAELOOP = System::Word(0x274e);
static const System::Word Id_WSAENAMETOOLONG = System::Word(0x274f);
static const System::Word Id_WSAEHOSTDOWN = System::Word(0x2750);
static const System::Word Id_WSAEHOSTUNREACH = System::Word(0x2751);
static const System::Word Id_WSAENOTEMPTY = System::Word(0x2752);
}	/* namespace Idstackconsts */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSTACKCONSTS)
using namespace Idstackconsts;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdstackconstsHPP
