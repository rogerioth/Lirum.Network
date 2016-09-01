//
//  DHInet.m
//  InetTest
//
//  Created by Rogerio Tomio Hirooka on 12/22/11.
//  Copyright (c) 2011 Lirum Labs T Sistemas. All rights reserved.
//

#define INET6 1

#import "DHInet.h"
#import "privateheader.h"

#ifdef INET6
#include "ip6.h"
//#include <netinet/ip6.h>

#include "socketvar.h"
#include <sys/ioctl.h>

//#include "sys/mbuf.h"
//#include <sys/protosw.h>

//#include <net/route.h>
//#include <net/if.h>
//#include <net/if_var.h>
//#include <netinet/in.h>
//#include <netinet/ip6.h>
//#include <netinet/icmp6.h>
//#include <netinet/in_systm.h>
//#include <netinet6/in6_pcb.h>
//#include <netinet6/in6_var.h>
//#include <netinet6/ip6_var.h>
//#include <netinet6/pim6_var.h>
//#include <netinet6/raw_ip6.h>

#include <arpa/inet.h>
#include <netdb.h>

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "netstat.h"

//#import "DNSUtil.h"
#import "DNS.h"

#endif /* INET6 */

@implementation DHInet

#define  SO_TC_MAX	10

#ifdef INET6
extern void	inet6print (struct in6_addr *, int, char *, int);
static int udp_done, tcp_done;
extern int mptcp_done;
#endif /* INET6 */



/////////

#ifdef INET6

char	*inet6name (struct in6_addr *);
void	inet6print (struct in6_addr *, int, char *, int);

static char ntop_buf[INET6_ADDRSTRLEN];
//
//static	char *ip6nh[] = {
//    "hop by hop",
//    "ICMP",
//    "IGMP",
//    "#3",
//    "IP",
//    "#5",
//    "TCP",
//    "#7",
//    "#8",
//    "#9",
//    "#10",
//    "#11",
//    "#12",
//    "#13",
//    "#14",
//    "#15",
//    "#16",
//    "UDP",
//    "#18",
//    "#19",
//    "#20",
//    "#21",
//    "IDP",
//    "#23",
//    "#24",
//    "#25",
//    "#26",
//    "#27",
//    "#28",
//    "TP",
//    "#30",
//    "#31",
//    "#32",
//    "#33",
//    "#34",
//    "#35",
//    "#36",
//    "#37",
//    "#38",
//    "#39",
//    "#40",
//    "IP6",
//    "#42",
//    "routing",
//    "fragment",
//    "#45",
//    "#46",
//    "#47",
//    "#48",
//    "#49",
//    "ESP",
//    "AH",
//    "#52",
//    "#53",
//    "#54",
//    "#55",
//    "#56",
//    "#57",
//    "ICMP6",
//    "no next header",
//    "destination option",
//    "#61",
//    "#62",
//    "#63",
//    "#64",
//    "#65",
//    "#66",
//    "#67",
//    "#68",
//    "#69",
//    "#70",
//    "#71",
//    "#72",
//    "#73",
//    "#74",
//    "#75",
//    "#76",
//    "#77",
//    "#78",
//    "#79",
//    "ISOIP",
//    "#81",
//    "#82",
//    "#83",
//    "#84",
//    "#85",
//    "#86",
//    "#87",
//    "#88",
//    "OSPF",
//    "#80",
//    "#91",
//    "#92",
//    "#93",
//    "#94",
//    "#95",
//    "#96",
//    "Ethernet",
//    "#98",
//    "#99",
//    "#100",
//    "#101",
//    "#102",
//    "PIM",
//    "#104",
//    "#105",
//    "#106",
//    "#107",
//    "#108",
//    "#109",
//    "#110",
//    "#111",
//    "#112",
//    "#113",
//    "#114",
//    "#115",
//    "#116",
//    "#117",
//    "#118",
//    "#119",
//    "#120",
//    "#121",
//    "#122",
//    "#123",
//    "#124",
//    "#125",
//    "#126",
//    "#127",
//    "#128",
//    "#129",
//    "#130",
//    "#131",
//    "#132",
//    "#133",
//    "#134",
//    "#135",
//    "#136",
//    "#137",
//    "#138",
//    "#139",
//    "#140",
//    "#141",
//    "#142",
//    "#143",
//    "#144",
//    "#145",
//    "#146",
//    "#147",
//    "#148",
//    "#149",
//    "#150",
//    "#151",
//    "#152",
//    "#153",
//    "#154",
//    "#155",
//    "#156",
//    "#157",
//    "#158",
//    "#159",
//    "#160",
//    "#161",
//    "#162",
//    "#163",
//    "#164",
//    "#165",
//    "#166",
//    "#167",
//    "#168",
//    "#169",
//    "#170",
//    "#171",
//    "#172",
//    "#173",
//    "#174",
//    "#175",
//    "#176",
//    "#177",
//    "#178",
//    "#179",
//    "#180",
//    "#181",
//    "#182",
//    "#183",
//    "#184",
//    "#185",
//    "#186",
//    "#187",
//    "#188",
//    "#189",
//    "#180",
//    "#191",
//    "#192",
//    "#193",
//    "#194",
//    "#195",
//    "#196",
//    "#197",
//    "#198",
//    "#199",
//    "#200",
//    "#201",
//    "#202",
//    "#203",
//    "#204",
//    "#205",
//    "#206",
//    "#207",
//    "#208",
//    "#209",
//    "#210",
//    "#211",
//    "#212",
//    "#213",
//    "#214",
//    "#215",
//    "#216",
//    "#217",
//    "#218",
//    "#219",
//    "#220",
//    "#221",
//    "#222",
//    "#223",
//    "#224",
//    "#225",
//    "#226",
//    "#227",
//    "#228",
//    "#229",
//    "#230",
//    "#231",
//    "#232",
//    "#233",
//    "#234",
//    "#235",
//    "#236",
//    "#237",
//    "#238",
//    "#239",
//    "#240",
//    "#241",
//    "#242",
//    "#243",
//    "#244",
//    "#245",
//    "#246",
//    "#247",
//    "#248",
//    "#249",
//    "#250",
//    "#251",
//    "#252",
//    "#253",
//    "#254",
//    "#255",
//};
//
///*
// * Dump IP6 statistics structure.
// */
//void
//ip6_stats(u_long off __unused, char *name, int af __unused)
//{
//    struct ip6stat ip6stat;
//    int first, i;
//    int mib[4];
//    size_t len;
//    
//    mib[0] = CTL_NET;
//    mib[1] = PF_INET6;
//    mib[2] = IPPROTO_IPV6;
//    mib[3] = IPV6CTL_STATS;
//    
//    len = sizeof ip6stat;
//    memset(&ip6stat, 0, len);
//    if (sysctl(mib, 4, &ip6stat, &len, (void *)0, 0) < 0)
//        return;
//    printf("%s:\n", name);
//    
//#define	p(f, m) if (ip6stat.f || sflag <= 1) \
//printf(m, (unsigned long long)ip6stat.f, plural(ip6stat.f))
//#define	p1a(f, m) if (ip6stat.f || sflag <= 1) \
//printf(m, (unsigned long long)ip6stat.f)
//    
//    p(ip6s_total, "\t%llu total packet%s received\n");
//    p1a(ip6s_toosmall, "\t%llu with size smaller than minimum\n");
//    p1a(ip6s_tooshort, "\t%llu with data size < data length\n");
//    p1a(ip6s_badoptions, "\t%llu with bad options\n");
//    p1a(ip6s_badvers, "\t%llu with incorrect version number\n");
//    p(ip6s_fragments, "\t%llu fragment%s received\n");
//    p(ip6s_fragdropped, "\t%llu fragment%s dropped (dup or out of space)\n");
//    p(ip6s_fragtimeout, "\t%llu fragment%s dropped after timeout\n");
//    p(ip6s_fragoverflow, "\t%llu fragment%s that exceeded limit\n");
//    p(ip6s_reassembled, "\t%llu packet%s reassembled ok\n");
//    p(ip6s_delivered, "\t%llu packet%s for this host\n");
//    p(ip6s_forward, "\t%llu packet%s forwarded\n");
//    p(ip6s_cantforward, "\t%llu packet%s not forwardable\n");
//    p(ip6s_redirectsent, "\t%llu redirect%s sent\n");
//    p(ip6s_localout, "\t%llu packet%s sent from this host\n");
//    p(ip6s_rawout, "\t%llu packet%s sent with fabricated ip header\n");
//    p(ip6s_odropped, "\t%llu output packet%s dropped due to no bufs, etc.\n");
//    p(ip6s_noroute, "\t%llu output packet%s discarded due to no route\n");
//    p(ip6s_fragmented, "\t%llu output datagram%s fragmented\n");
//    p(ip6s_ofragments, "\t%llu fragment%s created\n");
//    p(ip6s_cantfrag, "\t%llu datagram%s that can't be fragmented\n");
//    p(ip6s_badscope, "\t%llu packet%s that violated scope rules\n");
//    p(ip6s_notmember, "\t%llu multicast packet%s which we don't join\n");
//    for (first = 1, i = 0; i < 256; i++)
//        if (ip6stat.ip6s_nxthist[i] != 0) {
//            if (first) {
//                printf("\tInput histogram:\n");
//                first = 0;
//            }
//            printf("\t\t%s: %llu\n", ip6nh[i],
//                   (unsigned long long)ip6stat.ip6s_nxthist[i]);
//        }
//    printf("\tMbuf statistics:\n");
//    printf("\t\t%llu one mbuf\n", (unsigned long long)ip6stat.ip6s_m1);
//    for (first = 1, i = 0; i < 32; i++) {
//        char ifbuf[IFNAMSIZ];
//        if (ip6stat.ip6s_m2m[i] != 0) {
//            if (first) {
//                printf("\t\ttwo or more mbuf:\n");
//                first = 0;
//            }
//            printf("\t\t\t%s= %llu\n",
//                   if_indextoname(i, ifbuf),
//                   (unsigned long long)ip6stat.ip6s_m2m[i]);
//        }
//    }
//    printf("\t\t%llu one ext mbuf\n",
//           (unsigned long long)ip6stat.ip6s_mext1);
//    printf("\t\t%llu two or more ext mbuf\n",
//           (unsigned long long)ip6stat.ip6s_mext2m);
//    p(ip6s_exthdrtoolong,
//      "\t%llu packet%s whose headers are not continuous\n");
//    p(ip6s_nogif, "\t%llu tunneling packet%s that can't find gif\n");
//    p(ip6s_toomanyhdr,
//      "\t%llu packet%s discarded due to too may headers\n");
//    
//    /* for debugging source address selection */
//#define PRINT_SCOPESTAT(s,i) do {\
//switch(i) { /* XXX hardcoding in each case */\
//case 1:\
//p(s, "\t\t%llu node-local%s\n");\
//break;\
//case 2:\
//p(s,"\t\t%llu link-local%s\n");\
//break;\
//case 5:\
//p(s,"\t\t%llu site-local%s\n");\
//break;\
//case 14:\
//p(s,"\t\t%llu global%s\n");\
//break;\
//default:\
//printf("\t\t%llu addresses scope=%x\n",\
//(unsigned long long)ip6stat.s, i);\
//}\
//} while (0);
//    
//    p(ip6s_sources_none,
//      "\t%llu failure%s of source address selection\n");
//    for (first = 1, i = 0; i < 16; i++) {
//        if (ip6stat.ip6s_sources_sameif[i]) {
//            if (first) {
//                printf("\tsource addresses on an outgoing I/F\n");
//                first = 0;
//            }
//            PRINT_SCOPESTAT(ip6s_sources_sameif[i], i);
//        }
//    }
//    for (first = 1, i = 0; i < 16; i++) {
//        if (ip6stat.ip6s_sources_otherif[i]) {
//            if (first) {
//                printf("\tsource addresses on a non-outgoing I/F\n");
//                first = 0;
//            }
//            PRINT_SCOPESTAT(ip6s_sources_otherif[i], i);
//        }
//    }
//    for (first = 1, i = 0; i < 16; i++) {
//        if (ip6stat.ip6s_sources_samescope[i]) {
//            if (first) {
//                printf("\tsource addresses of same scope\n");
//                first = 0;
//            }
//            PRINT_SCOPESTAT(ip6s_sources_samescope[i], i);
//        }
//    }
//    for (first = 1, i = 0; i < 16; i++) {
//        if (ip6stat.ip6s_sources_otherscope[i]) {
//            if (first) {
//                printf("\tsource addresses of a different scope\n");
//                first = 0;
//            }
//            PRINT_SCOPESTAT(ip6s_sources_otherscope[i], i);
//        }
//    }
//    for (first = 1, i = 0; i < 16; i++) {
//        if (ip6stat.ip6s_sources_deprecated[i]) {
//            if (first) {
//                printf("\tdeprecated source addresses\n");
//                first = 0;
//            }
//            PRINT_SCOPESTAT(ip6s_sources_deprecated[i], i);
//        }
//    }
//    
//    p1a(ip6s_forward_cachehit, "\t%llu forward cache hit\n");
//    p1a(ip6s_forward_cachemiss, "\t%llu forward cache miss\n");
//#undef p
//#undef p1a
//}

///*
// * Dump IPv6 per-interface statistics based on RFC 2465.
// */
//void
//ip6_ifstats(char *ifname)
//{
//    struct in6_ifreq ifr;
//    int s;
//#define	p(f, m) if (ifr.ifr_ifru.ifru_stat.f || sflag <= 1) \
//printf(m, (unsigned long long)ifr.ifr_ifru.ifru_stat.f, plural(ifr.ifr_ifru.ifru_stat.f))
//#define	p_5(f, m) if (ifr.ifr_ifru.ifru_stat.f || sflag <= 1) \
//printf(m, (unsigned long long)ip6stat.f)
//    
//    if ((s = socket(AF_INET6, SOCK_DGRAM, 0)) < 0) {
//        perror("Warning: socket(AF_INET6)");
//        return;
//    }
//    
//    strcpy(ifr.ifr_name, ifname);
//    printf("ip6 on %s:\n", ifr.ifr_name);
//    
//    if (ioctl(s, SIOCGIFSTAT_IN6, (char *)&ifr) < 0) {
//        perror("Warning: ioctl(SIOCGIFSTAT_IN6)");
//        goto end;
//    }
//    
//    p(ifs6_in_receive, "\t%llu total input datagram%s\n");
//    p(ifs6_in_hdrerr, "\t%llu datagram%s with invalid header received\n");
//    p(ifs6_in_toobig, "\t%llu datagram%s exceeded MTU received\n");
//    p(ifs6_in_noroute, "\t%llu datagram%s with no route received\n");
//    p(ifs6_in_addrerr, "\t%llu datagram%s with invalid dst received\n");
//    p(ifs6_in_protounknown, "\t%llu datagram%s with unknown proto received\n");
//    p(ifs6_in_truncated, "\t%llu truncated datagram%s received\n");
//    p(ifs6_in_discard, "\t%llu input datagram%s discarded\n");
//    p(ifs6_in_deliver,
//      "\t%llu datagram%s delivered to an upper layer protocol\n");
//    p(ifs6_out_forward, "\t%llu datagram%s forwarded to this interface\n");
//    p(ifs6_out_request,
//      "\t%llu datagram%s sent from an upper layer protocol\n");
//    p(ifs6_out_discard, "\t%llu total discarded output datagram%s\n");
//    p(ifs6_out_fragok, "\t%llu output datagram%s fragmented\n");
//    p(ifs6_out_fragfail, "\t%llu output datagram%s failed on fragment\n");
//    p(ifs6_out_fragcreat, "\t%llu output datagram%s succeeded on fragment\n");
//    p(ifs6_reass_reqd, "\t%llu incoming datagram%s fragmented\n");
//    p(ifs6_reass_ok, "\t%llu datagram%s reassembled\n");
//    p(ifs6_reass_fail, "\t%llu datagram%s failed on reassembling\n");
//    p(ifs6_in_mcast, "\t%llu multicast datagram%s received\n");
//    p(ifs6_out_mcast, "\t%llu multicast datagram%s sent\n");
//    
//end:
//    close(s);
//    
//#undef p
//#undef p_5
//}

//static	char *icmp6names[] = {
//    "#0",
//    "unreach",
//    "packet too big",
//    "time exceed",
//    "parameter problem",
//    "#5",
//    "#6",
//    "#7",
//    "#8",
//    "#9",
//    "#10",
//    "#11",
//    "#12",
//    "#13",
//    "#14",
//    "#15",
//    "#16",
//    "#17",
//    "#18",
//    "#19",
//    "#20",
//    "#21",
//    "#22",
//    "#23",
//    "#24",
//    "#25",
//    "#26",
//    "#27",
//    "#28",
//    "#29",
//    "#30",
//    "#31",
//    "#32",
//    "#33",
//    "#34",
//    "#35",
//    "#36",
//    "#37",
//    "#38",
//    "#39",
//    "#40",
//    "#41",
//    "#42",
//    "#43",
//    "#44",
//    "#45",
//    "#46",
//    "#47",
//    "#48",
//    "#49",
//    "#50",
//    "#51",
//    "#52",
//    "#53",
//    "#54",
//    "#55",
//    "#56",
//    "#57",
//    "#58",
//    "#59",
//    "#60",
//    "#61",
//    "#62",
//    "#63",
//    "#64",
//    "#65",
//    "#66",
//    "#67",
//    "#68",
//    "#69",
//    "#70",
//    "#71",
//    "#72",
//    "#73",
//    "#74",
//    "#75",
//    "#76",
//    "#77",
//    "#78",
//    "#79",
//    "#80",
//    "#81",
//    "#82",
//    "#83",
//    "#84",
//    "#85",
//    "#86",
//    "#87",
//    "#88",
//    "#89",
//    "#80",
//    "#91",
//    "#92",
//    "#93",
//    "#94",
//    "#95",
//    "#96",
//    "#97",
//    "#98",
//    "#99",
//    "#100",
//    "#101",
//    "#102",
//    "#103",
//    "#104",
//    "#105",
//    "#106",
//    "#107",
//    "#108",
//    "#109",
//    "#110",
//    "#111",
//    "#112",
//    "#113",
//    "#114",
//    "#115",
//    "#116",
//    "#117",
//    "#118",
//    "#119",
//    "#120",
//    "#121",
//    "#122",
//    "#123",
//    "#124",
//    "#125",
//    "#126",
//    "#127",
//    "echo",
//    "echo reply",
//    "multicast listener query",
//    "multicast listener report",
//    "multicast listener done",
//    "router solicitation",
//    "router advertisement",
//    "neighbor solicitation",
//    "neighbor advertisement",
//    "redirect",
//    "router renumbering",
//    "node information request",
//    "node information reply",
//    "inverse neighbor solicitation",
//    "inverse neighbor advertisement",
//    "#143",
//    "#144",
//    "#145",
//    "#146",
//    "#147",
//    "#148",
//    "#149",
//    "#150",
//    "#151",
//    "#152",
//    "#153",
//    "#154",
//    "#155",
//    "#156",
//    "#157",
//    "#158",
//    "#159",
//    "#160",
//    "#161",
//    "#162",
//    "#163",
//    "#164",
//    "#165",
//    "#166",
//    "#167",
//    "#168",
//    "#169",
//    "#170",
//    "#171",
//    "#172",
//    "#173",
//    "#174",
//    "#175",
//    "#176",
//    "#177",
//    "#178",
//    "#179",
//    "#180",
//    "#181",
//    "#182",
//    "#183",
//    "#184",
//    "#185",
//    "#186",
//    "#187",
//    "#188",
//    "#189",
//    "#180",
//    "#191",
//    "#192",
//    "#193",
//    "#194",
//    "#195",
//    "#196",
//    "#197",
//    "#198",
//    "#199",
//    "#200",
//    "#201",
//    "#202",
//    "#203",
//    "#204",
//    "#205",
//    "#206",
//    "#207",
//    "#208",
//    "#209",
//    "#210",
//    "#211",
//    "#212",
//    "#213",
//    "#214",
//    "#215",
//    "#216",
//    "#217",
//    "#218",
//    "#219",
//    "#220",
//    "#221",
//    "#222",
//    "#223",
//    "#224",
//    "#225",
//    "#226",
//    "#227",
//    "#228",
//    "#229",
//    "#230",
//    "#231",
//    "#232",
//    "#233",
//    "#234",
//    "#235",
//    "#236",
//    "#237",
//    "#238",
//    "#239",
//    "#240",
//    "#241",
//    "#242",
//    "#243",
//    "#244",
//    "#245",
//    "#246",
//    "#247",
//    "#248",
//    "#249",
//    "#250",
//    "#251",
//    "#252",
//    "#253",
//    "#254",
//    "#255",
//};

///*
// * Dump ICMP6 statistics.
// */
//void
//icmp6_stats(u_long off __unused, char *name, int af __unused)
//{
//    struct icmp6stat icmp6stat;
//    register int i, first;
//    int mib[4];
//    size_t len;
//    
//    mib[0] = CTL_NET;
//    mib[1] = PF_INET6;
//    mib[2] = IPPROTO_ICMPV6;
//    mib[3] = ICMPV6CTL_STATS;
//    
//    len = sizeof icmp6stat;
//    memset(&icmp6stat, 0, len);
//    if (sysctl(mib, 4, &icmp6stat, &len, (void *)0, 0) < 0)
//        return;
//    printf("%s:\n", name);
//    
//#define	p(f, m) if (icmp6stat.f || sflag <= 1) \
//printf(m, (unsigned long long)icmp6stat.f, plural(icmp6stat.f))
//#define p_5(f, m) printf(m, (unsigned long long)icmp6stat.f)
//    
//    p(icp6s_error, "\t%llu call%s to icmp_error\n");
//    p(icp6s_canterror,
//      "\t%llu error%s not generated because old message was icmp error or so\n");
//    p(icp6s_toofreq,
//      "\t%llu error%s not generated because rate limitation\n");
//#define NELEM (sizeof(icmp6stat.icp6s_outhist)/sizeof(icmp6stat.icp6s_outhist[0]))
//    for (first = 1, i = 0; i < NELEM; i++)
//        if (icmp6stat.icp6s_outhist[i] != 0) {
//            if (first) {
//                printf("\tOutput histogram:\n");
//                first = 0;
//            }
//            printf("\t\t%s: %llu\n", icmp6names[i],
//                   (unsigned long long)icmp6stat.icp6s_outhist[i]);
//        }
//#undef NELEM
//    p(icp6s_badcode, "\t%llu message%s with bad code fields\n");
//    p(icp6s_tooshort, "\t%llu message%s < minimum length\n");
//    p(icp6s_checksum, "\t%llu bad checksum%s\n");
//    p(icp6s_badlen, "\t%llu message%s with bad length\n");
//#define NELEM (sizeof(icmp6stat.icp6s_inhist)/sizeof(icmp6stat.icp6s_inhist[0]))
//    for (first = 1, i = 0; i < NELEM; i++)
//        if (icmp6stat.icp6s_inhist[i] != 0) {
//            if (first) {
//                printf("\tInput histogram:\n");
//                first = 0;
//            }
//            printf("\t\t%s: %llu\n", icmp6names[i],
//                   (unsigned long long)icmp6stat.icp6s_inhist[i]);
//        }
//#undef NELEM
//    printf("\tHistogram of error messages to be generated:\n");
//    p_5(icp6s_odst_unreach_noroute, "\t\t%llu no route\n");
//    p_5(icp6s_odst_unreach_admin, "\t\t%llu administratively prohibited\n");
//    p_5(icp6s_odst_unreach_beyondscope, "\t\t%llu beyond scope\n");
//    p_5(icp6s_odst_unreach_addr, "\t\t%llu address unreachable\n");
//    p_5(icp6s_odst_unreach_noport, "\t\t%llu port unreachable\n");
//    p_5(icp6s_opacket_too_big, "\t\t%llu packet too big\n");
//    p_5(icp6s_otime_exceed_transit, "\t\t%llu time exceed transit\n");
//    p_5(icp6s_otime_exceed_reassembly, "\t\t%llu time exceed reassembly\n");
//    p_5(icp6s_oparamprob_header, "\t\t%llu erroneous header field\n");
//    p_5(icp6s_oparamprob_nextheader, "\t\t%llu unrecognized next header\n");
//    p_5(icp6s_oparamprob_option, "\t\t%llu unrecognized option\n");
//    p_5(icp6s_oredirect, "\t\t%llu redirect\n");
//    p_5(icp6s_ounknown, "\t\t%llu unknown\n");
//    
//    p(icp6s_reflect, "\t%llu message response%s generated\n");
//    p(icp6s_nd_toomanyopt, "\t%llu message%s with too many ND options\n");
//    p(icp6s_nd_badopt, "\t%qu message%s with bad ND options\n");
//    p(icp6s_badns, "\t%qu bad neighbor solicitation message%s\n");
//    p(icp6s_badna, "\t%qu bad neighbor advertisement message%s\n");
//    p(icp6s_badrs, "\t%qu bad router solicitation message%s\n");
//    p(icp6s_badra, "\t%qu bad router advertisement message%s\n");
//    p(icp6s_badredirect, "\t%qu bad redirect message%s\n");
//    p(icp6s_pmtuchg, "\t%llu path MTU change%s\n");
//#undef p
//#undef p_5
//}

///*
// * Dump ICMPv6 per-interface statistics based on RFC 2466.
// */
//void
//icmp6_ifstats(char *ifname)
//{
//    struct in6_ifreq ifr;
//    int s;
//#define	p(f, m) if (ifr.ifr_ifru.ifru_icmp6stat.f || sflag <= 1) \
//printf(m, (unsigned long long)ifr.ifr_ifru.ifru_icmp6stat.f, plural(ifr.ifr_ifru.ifru_icmp6stat.f))
//    
//    if ((s = socket(AF_INET6, SOCK_DGRAM, 0)) < 0) {
//        perror("Warning: socket(AF_INET6)");
//        return;
//    }
//    
//    strcpy(ifr.ifr_name, ifname);
//    printf("icmp6 on %s:\n", ifr.ifr_name);
//    
//    if (ioctl(s, SIOCGIFSTAT_ICMP6, (char *)&ifr) < 0) {
//        perror("Warning: ioctl(SIOCGIFSTAT_ICMP6)");
//        goto end;
//    }
//    
//    p(ifs6_in_msg, "\t%llu total input message%s\n");
//    p(ifs6_in_error, "\t%llu total input error message%s\n");
//    p(ifs6_in_dstunreach, "\t%llu input destination unreachable error%s\n");
//    p(ifs6_in_adminprohib, "\t%llu input administratively prohibited error%s\n");
//    p(ifs6_in_timeexceed, "\t%llu input time exceeded error%s\n");
//    p(ifs6_in_paramprob, "\t%llu input parameter problem error%s\n");
//    p(ifs6_in_pkttoobig, "\t%llu input packet too big error%s\n");
//    p(ifs6_in_echo, "\t%llu input echo request%s\n");
//    p(ifs6_in_echoreply, "\t%llu input echo reply%s\n");
//    p(ifs6_in_routersolicit, "\t%llu input router solicitation%s\n");
//    p(ifs6_in_routeradvert, "\t%llu input router advertisement%s\n");
//    p(ifs6_in_neighborsolicit, "\t%llu input neighbor solicitation%s\n");
//    p(ifs6_in_neighboradvert, "\t%llu input neighbor advertisement%s\n");
//    p(ifs6_in_redirect, "\t%llu input redirect%s\n");
//    p(ifs6_in_mldquery, "\t%llu input MLD query%s\n");
//    p(ifs6_in_mldreport, "\t%llu input MLD report%s\n");
//    p(ifs6_in_mlddone, "\t%llu input MLD done%s\n");
//    
//    p(ifs6_out_msg, "\t%llu total output message%s\n");
//    p(ifs6_out_error, "\t%llu total output error message%s\n");
//    p(ifs6_out_dstunreach, "\t%llu output destination unreachable error%s\n");
//    p(ifs6_out_adminprohib, "\t%llu output administratively prohibited error%s\n");
//    p(ifs6_out_timeexceed, "\t%llu output time exceeded error%s\n");
//    p(ifs6_out_paramprob, "\t%llu output parameter problem error%s\n");
//    p(ifs6_out_pkttoobig, "\t%llu output packet too big error%s\n");
//    p(ifs6_out_echo, "\t%llu output echo request%s\n");
//    p(ifs6_out_echoreply, "\t%llu output echo reply%s\n");
//    p(ifs6_out_routersolicit, "\t%llu output router solicitation%s\n");
//    p(ifs6_out_routeradvert, "\t%llu output router advertisement%s\n");
//    p(ifs6_out_neighborsolicit, "\t%llu output neighbor solicitation%s\n");
//    p(ifs6_out_neighboradvert, "\t%llu output neighbor advertisement%s\n");
//    p(ifs6_out_redirect, "\t%llu output redirect%s\n");
//    p(ifs6_out_mldquery, "\t%llu output MLD query%s\n");
//    p(ifs6_out_mldreport, "\t%llu output MLD report%s\n");
//    p(ifs6_out_mlddone, "\t%llu output MLD done%s\n");
//    
//end:
//    close(s);
//#undef p
//}

///*
// * Dump PIM statistics structure.
// */
//void
//pim6_stats(u_long off __unused, char *name, int af __unused)
//{
//    struct pim6stat pim6stat;
//    
//    if (off == 0)
//        return;
//    kread(off, (char *)&pim6stat, sizeof(pim6stat));
//    printf("%s:\n", name);
//    
//#define	p(f, m) if (pim6stat.f || sflag <= 1) \
//printf(m, (unsigned long long)pim6stat.f, plural(pim6stat.f))
//    p(pim6s_rcv_total, "\t%llu message%s received\n");
//    p(pim6s_rcv_tooshort, "\t%llu message%s received with too few bytes\n");
//    p(pim6s_rcv_badsum, "\t%llu message%s received with bad checksum\n");
//    p(pim6s_rcv_badversion, "\t%llu message%s received with bad version\n");
//    p(pim6s_rcv_registers, "\t%llu register%s received\n");
//    p(pim6s_rcv_badregisters, "\t%llu bad register%s received\n");
//    p(pim6s_snd_registers, "\t%llu register%s sent\n");
//#undef p
//}
//
///*
// * Dump raw ip6 statistics structure.
// */
//void
//rip6_stats(u_long off __unused, char *name, int af __unused)
//{
//    struct rip6stat rip6stat;
//    u_quad_t delivered;
//    int mib[4];
//    size_t l;
//    
//    mib[0] = CTL_NET;
//    mib[1] = PF_INET6;
//    mib[2] = IPPROTO_IPV6;
//    mib[3] = IPV6CTL_RIP6STATS;
//    l = sizeof(rip6stat);
//    if (sysctl(mib, 4, &rip6stat, &l, NULL, 0) < 0) {
//        perror("Warning: sysctl(net.inet6.ip6.rip6stats)");
//        return;
//    }
//    
//    printf("%s:\n", name);
//    
//#define	p(f, m) if (rip6stat.f || sflag <= 1) \
//printf(m, (unsigned long long)rip6stat.f, plural(rip6stat.f))
//    p(rip6s_ipackets, "\t%llu message%s received\n");
//    p(rip6s_isum, "\t%llu checksum calcuration%s on inbound\n");
//    p(rip6s_badsum, "\t%llu message%s with bad checksum\n");
//    p(rip6s_nosock, "\t%llu message%s dropped due to no socket\n");
//    p(rip6s_nosockmcast,
//      "\t%llu multicast message%s dropped due to no socket\n");
//    p(rip6s_fullsock,
//      "\t%llu message%s dropped due to full socket buffers\n");
//    delivered = rip6stat.rip6s_ipackets -
//    rip6stat.rip6s_badsum -
//    rip6stat.rip6s_nosock -
//    rip6stat.rip6s_nosockmcast -
//    rip6stat.rip6s_fullsock;
//    if (delivered || sflag <= 1)
//        printf("\t%llu delivered\n", (unsigned long long)delivered);
//    p(rip6s_opackets, "\t%llu datagram%s output\n");
//#undef p
//}

/*
 * Pretty print an Internet address (net address + port).
 * If the nflag was specified, use numbers instead of names.
 */
#define GETSERVBYPORT6(port, proto, ret)\
{\
if (strcmp((proto), "tcp6") == 0)\
(ret) = getservbyport((int)(port), "tcp");\
else if (strcmp((proto), "udp6") == 0)\
(ret) = getservbyport((int)(port), "udp");\
else\
(ret) = getservbyport((int)(port), (proto));\
};

void
inet6print(struct in6_addr *in6, int port, char *proto, int numeric)
{
    struct servent *sp = 0;
    char line[80], *cp;
    int width;
    
    sprintf(line, "%.*s.", lflag ? 39 :
            (Aflag && !numeric) ? 12 : 16, inet6name(in6));
    cp = index(line, '\0');
    if (!numeric && port)
        GETSERVBYPORT6(port, proto, sp);
    if (sp || port == 0)
        sprintf(cp, "%.8s", sp ? sp->s_name : "*");
    else
        sprintf(cp, "%d", ntohs((u_short)port));
    width = lflag ? 45 : Aflag ? 18 : 22;
    printf("%-*.*s ", width, width, line);
}

NSString *
customInet6print(struct in6_addr *in6, int port, char *proto, int numeric)
{
//    struct servent *sp = 0;
//    static char line[80], *cp;
////    int width;
//    
////    sprintf(line, "%.*s.", lflag ? 39 :
////            (Aflag && !numeric) ? 12 : 16, inet6name(in6));
//    
//    nflag = 1;
//    sprintf(line, "%s.", inet6name(in6));
//    
////    inet6name(in6);
////    
////    nflag = 0;
////    sprintf(line, "%s//%s.", line, inet6name(in6));
//    
//    cp = index(line, '\0');
//    if (!numeric && port)
//        GETSERVBYPORT6(port, proto, sp);
//    if (sp || port == 0)
//        sprintf(cp, "%.8s", sp ? sp->s_name : "*");
//    else
//        sprintf(cp, "%d", ntohs((u_short)port));
////    width = lflag ? 45 : Aflag ? 18 : 22;
////    printf("%-*.*s ", width, width, line);
////    printf("%s.", line);
//    return (line);
    
    
    struct servent *sp = 0;
    static char line[80], *cp;
    //int width;
    
    sprintf(line, "%s.", inet6name(in6));
    
    cp = index(line, '\0');
    if (!numeric && port)
        GETSERVBYPORT6(port, proto, sp);
    if (sp || port == 0)
        sprintf(cp, "%.8s", sp ? sp->s_name : "*");
    else
        sprintf(cp, "%d", ntohs((u_short)port));
    //width = lflag ? 45 : Aflag ? 18 : 22;
    //printf("%-*.*s ", width, width, line);

//    printf(" %s ", line);
    
    NSString* sline = [NSString stringWithFormat:@"%s" ,line];
    sline = [sline stringByReplacingOccurrencesOfString:@".:" withString:@":"];
    
    return sline;
//
//    
//    return line;
}

/*
 * Construct an Internet address representation.
 * If the nflag has been supplied, give
 * numeric value, otherwise try for symbolic name.
 */

char *
inet6name(struct in6_addr *in6p)
{
    register char *cp;
    static char line[50];
    struct hostent *hp;
    static char domain[MAXHOSTNAMELEN];
    static int first = 1;
    
    if (first && !nflag) {
        first = 0;
        if (gethostname(domain, MAXHOSTNAMELEN) == 0 &&
            (cp = index(domain, '.')))
            (void) strcpy(domain, cp + 1);
        else
            domain[0] = 0;
    }
    cp = 0;
    if (!nflag && !IN6_IS_ADDR_UNSPECIFIED(in6p)) {
        hp = gethostbyaddr((char *)in6p, sizeof(*in6p), AF_INET6);
        if (hp) {
            if ((cp = index(hp->h_name, '.')) &&
                !strcmp(cp + 1, domain))
                *cp = 0;
            cp = hp->h_name;
        }
    }
    if (IN6_IS_ADDR_UNSPECIFIED(in6p))
        strcpy(line, "*");
    else if (cp)
        strcpy(line, cp);
    else 
        sprintf(line, "%s",
                inet_ntop(AF_INET6, (void *)in6p, ntop_buf,
                          sizeof(ntop_buf)));
    return (line);
}
#endif /*INET6*/

/////////



/*
 * Construct an Internet address representation.
 * If the nflag has been supplied, give
 * numeric value, otherwise try for symbolic name.
 */
char *
inetname(struct in_addr *inp)
{
    register char *cp;
    static char line[MAXHOSTNAMELEN];
    struct hostent *hp;
    struct netent *np;
    
    cp = 0;
    if (!nflag && inp->s_addr != INADDR_ANY) {
        int net = inet_netof(*inp);
        int lna = inet_lnaof(*inp);
        
        if (lna == INADDR_ANY) {
            np = getnetbyaddr(net, AF_INET);
            if (np)
                cp = np->n_name;
        }
        if (cp == 0) {
            hp = gethostbyaddr((char *)inp, sizeof (*inp), AF_INET);
            if (hp) {
                cp = hp->h_name;
                //### trimdomain(cp, strlen(cp));
            }
        }
    }
    if (inp->s_addr == INADDR_ANY)
        strcpy(line, "*");
    else if (cp) {
        strncpy(line, cp, sizeof(line) - 1);
        line[sizeof(line) - 1] = '\0';
    } else {
        inp->s_addr = ntohl(inp->s_addr);
#define C(x)	((u_int)((x) & 0xff))
        sprintf(line, "%u.%u.%u.%u", C(inp->s_addr >> 24),
                C(inp->s_addr >> 16), C(inp->s_addr >> 8), C(inp->s_addr));
    }
    return (line);
}




/*
 * Pretty print an Internet address (net address + port).
 */
void
inetprint(struct in_addr *in, int port, char *proto, int numeric_port)
{
    struct servent *sp = 0;
    char line[80], *cp;
    int width;
    
    if (Wflag)
        sprintf(line, "%s.", inetname(in));
    else
        sprintf(line, "%.*s.", (Aflag && !numeric_port) ? 12 : 16, inetname(in));
    cp = index(line, '\0');
    if (!numeric_port && port)
        sp = getservbyport((int)port, proto);
    if (sp || port == 0)
        sprintf(cp, "%.15s ", sp ? sp->s_name : "*");
    else
        sprintf(cp, "%d ", ntohs((u_short)port));
    width = (Aflag && !Wflag) ? 18 : 22;
    
    
    if (Wflag)
        printf("%-*s ", width, line);
    else
        printf("%-*.*s ", width, width, line);
}

/*
 * Customization of inetprint method
 */
NSString *
customInetPrint(struct in_addr *in, int port, char *proto, int numeric_port)
{
//    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];

    // always use Wflag
    struct servent *sp = 0;
    static char line[80], *cp;
    //int width;
    
    nflag = 1;
    sprintf(line, "%s.", inetname(in));
    
    inetname(in);
//
//    nflag = 0;
//    sprintf(line, "%s//%s.", line, inetname(in));
    
    cp = index(line, '\0');
    
    if (!numeric_port && port)
        sp = getservbyport((int)port, proto);
    if (sp || port == 0)
        sprintf(cp, "%.15s ", sp ? sp->s_name : "*");
    else
        sprintf(cp, ":%d ", ntohs((u_short)port));
    
    //width = (Aflag && !Wflag) ? 18 : 22;
    
    NSString* sline = [NSString stringWithFormat:@"%s" ,line];
    sline = [sline stringByReplacingOccurrencesOfString:@".:" withString:@":"];
    
    return sline;
//    printf("%-*s ", width, line);
}

NSMutableArray *allItems = nil;

/*
 * Print a summary of connections related to an Internet
 * protocol.  For TCP, also give state of connection.
 * Listening processes (aflag) are suppressed unless the
 * -a (all) flag is specified.
 */
void
protopr(u_long proto,		/* for sysctl version we pass proto # */
        char *name, int af)
{
    int istcp;
    static int first = 1;
    char *buf;
    const char *mibvar;
    struct tcpcb *tp = NULL;
    struct inpcb *inp;
    struct xinpgen *xig, *oxig;
    struct xsocket *so;
    size_t len;
    
    //delete begin
    allItems = [[NSMutableArray alloc] init];
    //delete end
    
    istcp = 0;
    switch (proto) {
        case IPPROTO_TCP:
#ifdef INET6
            if (tcp_done != 0)
                return;
            else
                tcp_done = 1;
#endif
            istcp = 1;
            mibvar = "net.inet.tcp.pcblist";
            break;
        case IPPROTO_UDP:
#ifdef INET6
            if (udp_done != 0)
                return;
            else
                udp_done = 1;
#endif
            mibvar = "net.inet.udp.pcblist";
            break;
        case IPPROTO_DIVERT:
            mibvar = "net.inet.divert.pcblist";
            break;
        default:
            mibvar = "net.inet.raw.pcblist";
            break;
    }
    len = 0;
    if (sysctlbyname(mibvar, 0, &len, 0, 0) < 0) {
        if (errno != ENOENT)
            warn("sysctl: %s", mibvar);
        return;
    }
    if ((buf = malloc(len)) == 0) {
        warn("malloc %lu bytes", (u_long)len);
        return;
    }
    if (sysctlbyname(mibvar, buf, &len, 0, 0) < 0) {
        warn("sysctl: %s", mibvar);
        free(buf);
        return;
    }
    
    /*
     * Bail-out to avoid logic error in the loop below when
     * there is in fact no more control block to process
     */
    if (len <= sizeof(struct xinpgen)) {
        free(buf);
        return;
    }
    
    oxig = xig = (struct xinpgen *)buf;
    for (xig = (struct xinpgen *)((char *)xig + xig->xig_len);
         xig->xig_len > sizeof(struct xinpgen);
         xig = (struct xinpgen *)((char *)xig + xig->xig_len)) {
        
        NSMutableDictionary *returnedItem = [[NSMutableDictionary alloc] init];
        
        if (istcp) {
            tp = &((struct xtcpcb *)xig)->xt_tp;
            inp = &((struct xtcpcb *)xig)->xt_inp;
            so = &((struct xtcpcb *)xig)->xt_socket;
        } else {
            inp = &((struct xinpcb *)xig)->xi_inp;
            so = &((struct xinpcb *)xig)->xi_socket;
        }
        
        /* Ignore sockets for protocols other than the desired one. */
        if (so->xso_protocol != (int)proto)
            continue;
        
        /* Ignore PCBs which were freed during copyout. */
        if (inp->inp_gencnt > oxig->xig_gen)
            continue;
        
        if ((af == AF_INET && (inp->inp_vflag & INP_IPV4) == 0)
#ifdef INET6
            || (af == AF_INET6 && (inp->inp_vflag & INP_IPV6) == 0)
#endif /* INET6 */
            || (af == AF_UNSPEC && ((inp->inp_vflag & INP_IPV4) == 0
#ifdef INET6
                                    && (inp->inp_vflag &
                                        INP_IPV6) == 0
#endif /* INET6 */
                                    ))
            )
            continue;
        if (!aflag &&
            (
             (af == AF_INET &&
              inet_lnaof(inp->inp_laddr) == INADDR_ANY)
#ifdef INET6
             || (af == AF_INET6 &&
                 IN6_IS_ADDR_UNSPECIFIED(&inp->in6p_laddr))
#endif /* INET6 */
             || (af == AF_UNSPEC &&
                 (((inp->inp_vflag & INP_IPV4) != 0 &&
                   inet_lnaof(inp->inp_laddr) == INADDR_ANY)
#ifdef INET6
                  || ((inp->inp_vflag & INP_IPV6) != 0 &&
                      IN6_IS_ADDR_UNSPECIFIED(&inp->in6p_laddr))
#endif
                  ))
             ))
            continue;
        
        if (first) {
            if (!Lflag) {
                printf("Active Internet connections");
                if (aflag)
                    printf(" (including servers)");
            } else
                printf(
                       "Current listen queue sizes (qlen/incqlen/maxqlen)");
            putchar('\n');
            if (Aflag)
                printf("%-8.8s ", "Socket");
            if (Lflag)
                printf("%-14.14s %-22.22s\n",
                       "Listen", "Local Address");
            else
                printf((Aflag && !Wflag) ?
                       "%-5.5s %-6.6s %-6.6s  %-18.18s %-18.18s %s\n" :
                       "%-5.5s %-6.6s %-6.6s  %-22.22s %-22.22s %s\n",
                       "Proto", "Recv-Q", "Send-Q",
                       "Local Address", "Foreign Address",
                       "(state)");
            first = 0;
        }
        
        NSString* sline = @"";
        if (Aflag) {
//            char proto[6];

            if (istcp) {
                printf("%8lx ", (u_long)inp->inp_ppcb);
//                sprintf(proto,"%8lx ", (u_long)inp->inp_ppcb);
            }
            else {
                printf("%8lx ", (u_long)so->so_pcb);
//                sprintf(proto,"%8lx ", (u_long)inp->inp_ppcb);
            }
            
//            sline = [NSString stringWithFormat:@"%s" ,proto];
        }
        if (Lflag)
            if (so->so_qlimit) {
                char buf[15];
                
                snprintf(buf, 15, "%d/%d/%d", so->so_qlen,
                         so->so_incqlen, so->so_qlimit);
                printf("%-14.14s ", buf);
            } else
                continue;
            else {
                const char *vchar;
                
#ifdef INET6
                if ((inp->inp_vflag & INP_IPV6) != 0)
                    vchar = ((inp->inp_vflag & INP_IPV4) != 0)
                    ? "46" : "6 ";
                else
#endif
                    vchar = ((inp->inp_vflag & INP_IPV4) != 0)
                    ? "4 " : "  ";
                
                printf("%-3.3s%-2.2s %6u %6u  ", name, vchar,
                       so->so_rcv.sb_cc,
                       so->so_snd.sb_cc);
                
                NSString *recvq = [NSString stringWithFormat:@"%6u", so->so_rcv.sb_cc];
                NSString *sendq = [NSString stringWithFormat:@"%6u", so->so_snd.sb_cc];
                
                [returnedItem setObject:recvq forKey:@"recvq"];
                [returnedItem setObject:sendq forKey:@"sendq"];
                
                sline = [NSString stringWithFormat:@"%s%s", name, vchar];
                [returnedItem setObject:sline forKey:@"proto"];
            }
        
/////
        nflag = 1;
        if (inp->inp_vflag & INP_IPV4) {
            NSString *l = customInetPrint(&inp->inp_laddr, (int)inp->inp_lport,
                                          name, 1);
            
            // return data for the dictionary
            [returnedItem setObject:l forKey:@"local"];
//            [allItems addObject: l];
            
            if (!Lflag) {
                NSString *s = customInetPrint(&inp->inp_faddr,
                                              (int)inp->inp_fport, name, 1);
                [returnedItem setObject:s forKey:@"remote"];
//                [allItems addObject: s];
            }
            
            //NSLog(@"%@ %@", [returnedItem objectForKey:@"local"], [returnedItem objectForKey:@"remote"]);
        }
#ifdef INET6
        else if (inp->inp_vflag & INP_IPV6) {
            NSString *l = customInet6print(&inp->in6p_laddr,
                       (int)inp->inp_lport, name, 1);
            [returnedItem setObject:l forKey:@"local"];

            if (!Lflag) {
                NSString *s = customInet6print(&inp->in6p_faddr,
                                               (int)inp->inp_fport, name, 1);
                [returnedItem setObject:s forKey:@"remote"];
            }
        } /* else nothing printed now */
#endif /* INET6 */
    
        nflag = 1;

    if (inp->inp_flags & INP_ANONPORT) {
            if (inp->inp_vflag & INP_IPV4) {
                NSString *l = customInetPrint(&inp->inp_laddr, (int)inp->inp_lport,
                                              name, 1);
                [returnedItem setObject:l forKey:@"local.namedport"];
//                [allItems addObject: l];
                if (!Lflag) {
                    NSString *r = customInetPrint(&inp->inp_faddr,
                                                  (int)inp->inp_fport, name, 0);
                    [returnedItem setObject:r forKey:@"remote.namedport"];
//                    [allItems addObject: r];
                }
                
                //NSLog(@">> %@ %@", [returnedItem objectForKey:@"local.url"], [returnedItem objectForKey:@"remote.url"]);
            }
#ifdef INET6
            else if (inp->inp_vflag & INP_IPV6) {
                NSString *l = customInet6print(&inp->in6p_laddr,
                           (int)inp->inp_lport, name, 1);
                [returnedItem setObject:l forKey:@"local.namedport"];
                if (!Lflag) {
                    NSString *r = customInet6print(&inp->in6p_faddr,
                                                   (int)inp->inp_fport, name, 0);
                    [returnedItem setObject:r forKey:@"remote.namedport"];
                }
            } /* else nothing printed now */
#endif /* INET6 */
        } else {
            if (inp->inp_vflag & INP_IPV4) {
                NSString *l = customInetPrint(&inp->inp_laddr, (int)inp->inp_lport,
                                              name, 0);
                [returnedItem setObject:l forKey:@"local.namedport"];
//                [allItems addObject: l];
                
                if (!Lflag) {
                    NSString *r = customInetPrint(&inp->inp_faddr,
                                                  (int)inp->inp_fport, name,
                                                  inp->inp_lport !=
                                                  inp->inp_fport);
                    [returnedItem setObject:r forKey:@"remote.namedport"];
//                    [allItems addObject: r];
                }
                
                //NSLog(@">> %@ %@", [returnedItem objectForKey:@"local.url"], [returnedItem objectForKey:@"remote.url"]);
            }
#ifdef INET6
            else if (inp->inp_vflag & INP_IPV6) {
                NSString *l = customInet6print(&inp->in6p_laddr,
                           (int)inp->inp_lport, name, 0);
                [returnedItem setObject:l forKey:@"local.namedport"];
                if (!Lflag) {
                    NSString *r = customInet6print(&inp->in6p_faddr,
                                                   (int)inp->inp_fport, name,
                                                   inp->inp_lport !=
                                                   inp->inp_fport);
                    [returnedItem setObject:r forKey:@"remote.namedport"];
                }
            } /* else nothing printed now */
#endif /* INET6 */
        }
        
        
        
//        
//        
//        if (nflag) {
//            if (inp->inp_vflag & INP_IPV4) {
////                inetprint(&inp->inp_laddr, (int)inp->inp_lport,
////                          name, 1);
//                char *rline = customInetPrint(&inp->inp_laddr, (int)inp->inp_lport,
//                                      name, 1);
//                
//                NSString* sline = [NSString stringWithFormat:@"%s" ,rline];
//                sline = [sline stringByReplacingOccurrencesOfString:@".:" withString:@":"];
//                // return data for the dictionary
//                [returnedItem setObject:sline forKey:@"local"];
//                
//                if (!Lflag) {
////                    inetprint(&inp->inp_faddr,
////                              (int)inp->inp_fport, name, 1);
//                    
//                    char *pline = customInetPrint(&inp->inp_faddr,
//                                                  (int)inp->inp_fport, name, 1);
//                    NSString* spline = [NSString stringWithFormat:@"%s" ,pline];
//                    spline = [spline stringByReplacingOccurrencesOfString:@".:" withString:@":"];
//                    [returnedItem setObject:spline forKey:@"remote"];
//                }
//                
//                NSLog(@"%@ %@", [returnedItem objectForKey:@"local"], [returnedItem objectForKey:@"remote"]);
//            }
//#ifdef INET6
//            else if (inp->inp_vflag & INP_IPV6) {
//                inet6print(&inp->in6p_laddr,
//                           (int)inp->inp_lport, name, 1);
//                if (!Lflag)
//                    inet6print(&inp->in6p_faddr,
//                               (int)inp->inp_fport, name, 1);
//            } /* else nothing printed now */
//#endif /* INET6 */
//        } else if (inp->inp_flags & INP_ANONPORT) {
//            if (inp->inp_vflag & INP_IPV4) {
//                inetprint(&inp->inp_laddr, (int)inp->inp_lport,
//                          name, 1);
//                if (!Lflag)
//                    inetprint(&inp->inp_faddr,
//                              (int)inp->inp_fport, name, 0);
//            }
//#ifdef INET6
//            else if (inp->inp_vflag & INP_IPV6) {
//                inet6print(&inp->in6p_laddr,
//                           (int)inp->inp_lport, name, 1);
//                if (!Lflag)
//                    inet6print(&inp->in6p_faddr,
//                               (int)inp->inp_fport, name, 0);
//            } /* else nothing printed now */
//#endif /* INET6 */
//        } else {
//            if (inp->inp_vflag & INP_IPV4) {
//                inetprint(&inp->inp_laddr, (int)inp->inp_lport,
//                          name, 0);
//                if (!Lflag)
//                    inetprint(&inp->inp_faddr,
//                              (int)inp->inp_fport, name,
//                              inp->inp_lport !=
//                              inp->inp_fport);
//            }
//#ifdef INET6
//            else if (inp->inp_vflag & INP_IPV6) {
//                inet6print(&inp->in6p_laddr,
//                           (int)inp->inp_lport, name, 0);
//                if (!Lflag)
//                    inet6print(&inp->in6p_faddr,
//                               (int)inp->inp_fport, name,
//                               inp->inp_lport !=
//                               inp->inp_fport);
//            } /* else nothing printed now */
//#endif /* INET6 */
//        }
//        
//        
        
        
        
        if (istcp && !Lflag) {
            if (tp->t_state < 0 || tp->t_state >= TCP_NSTATES)
                printf("%d", tp->t_state);
            else {
                printf("%s", tcpstates[tp->t_state]);
                
                NSString* sline = [NSString stringWithFormat:@"%s" , tcpstates[tp->t_state]];
                [returnedItem setObject:sline forKey:@"state"];
                
#if defined(TF_NEEDSYN) && defined(TF_NEEDFIN)
                /* Show T/TCP `hidden state' */
                if (tp->t_flags & (TF_NEEDSYN|TF_NEEDFIN))
                    putchar('*');
#endif /* defined(TF_NEEDSYN) && defined(TF_NEEDFIN) */
            }
        }
        putchar('\n');
        
        
        [allItems addObject: returnedItem];
    }
    if (xig != oxig && xig->xig_gen != oxig->xig_gen) {
        if (oxig->xig_count > xig->xig_count) {
            printf("Some %s sockets may have been deleted.\n",
                   name);
        } else if (oxig->xig_count < xig->xig_count) {
            printf("Some %s sockets may have been created.\n",
                   name);
        } else {
            printf("Some %s sockets may have been created or deleted",
                   name);
        }
    }
    
//    DNS * dns = [[DNS alloc] init];
    
//    for (NSDictionary *d in allItems) {
//        // remove from ":" and after
//        // IMPORTANT: RDNS RESOLUTION
////        NSString *ip = [d componentsSeparatedByString:@":"][0];
////        NSString *rdns = [dns reverseDNS: ip];
////        
////        NSLog(@"%@ = %@", ip, rdns);
//        
//        NSLog(@"%@", d);
//        
//    }
    
    free(buf);
}

// You can change this flag to change the info showed.

int	Aflag = 1;	/* show addresses of protocol control block */
int	aflag = 1;	/* show all sockets (including servers) */
int	bflag = 1;	/* show i/f total bytes in/out */
int	Lflag = 0;	/* show size of listen queues */
int	Wflag = 1;	/* wide display */
int	prioflag = 0; /* show packet priority  statistics */
int	sflag = 0;	/* show protocol statistics */
int	nflag = 1;	/* show addresses numerically */
int	interval = 1; /* repeat interval for i/f stats */
int lflag = 0;

NSMutableArray *returnData = nil;

+ (NSMutableDictionary *) getTCPConnections{
    
    udp_done = 0;
    tcp_done = 0;
    returnData = nil;
    
    NSMutableDictionary *structuredReturn = [[NSMutableDictionary alloc] init];
    protopr(IPPROTO_TCP, "tcp", AF_INET);
    NSMutableArray *ip4tcp = [[NSMutableArray alloc] initWithArray: allItems];
    [structuredReturn setObject: ip4tcp forKey:@"IP4.TCP"];
    
    udp_done = 0;
    tcp_done = 0;
    
    protopr(IPPROTO_UDP, "ucp", AF_INET);
    NSMutableArray *ip4ucp = [[NSMutableArray alloc] initWithArray: allItems];
    [structuredReturn setObject: ip4ucp forKey:@"IP4.UCP"];
    
    udp_done = 0;
    tcp_done = 0;
    
    protopr(IPPROTO_UDP, "divert", IPPROTO_DIVERT);
    NSMutableArray *ip4divert = [[NSMutableArray alloc] initWithArray: allItems];
    [structuredReturn setObject: ip4divert forKey:@"IP4.DIVERT"];
    
    udp_done = 0;
    tcp_done = 0;
    
    protopr(IPPROTO_RAW, "icmp", AF_INET);
    NSMutableArray *icmp = [[NSMutableArray alloc] initWithArray: allItems];
    [structuredReturn setObject: icmp forKey:@"IP4.ICMP"];

    udp_done = 0;
    tcp_done = 0;

    protopr(IPPROTO_RAW, "igmp", AF_INET);
    NSMutableArray *igmp = [[NSMutableArray alloc] initWithArray: allItems];
    [structuredReturn setObject: igmp forKey:@"IP4.IGMP"];
    
    udp_done = 0;
    tcp_done = 0;

    protopr(IPPROTO_TCP, "tcp", AF_INET6);
    NSMutableArray *tcp6 = [[NSMutableArray alloc] initWithArray: allItems];
    [structuredReturn setObject: tcp6 forKey:@"IP6.TCP"];

    udp_done = 0;
    tcp_done = 0;
    
    protopr(IPPROTO_UDP, "ucp", AF_INET6);
    NSMutableArray *ucp6 = [[NSMutableArray alloc] initWithArray: allItems];
    [structuredReturn setObject: ucp6 forKey:@"IP6.UCP"];

    udp_done = 0;
    tcp_done = 0;
    
    protopr(IPPROTO_DIVERT, "divert", AF_INET6);
    NSMutableArray *divert6 = [[NSMutableArray alloc] initWithArray: allItems];
    [structuredReturn setObject: divert6 forKey:@"IP6.DIVERT"];

    udp_done = 0;
    tcp_done = 0;
    
    protopr(IPPROTO_RAW, "ip6", AF_INET6);
    NSMutableArray *ip6 = [[NSMutableArray alloc] initWithArray: allItems];
    [structuredReturn setObject: ip6 forKey:@"IP6"];

    udp_done = 0;
    tcp_done = 0;
    
    protopr(IPPROTO_RAW, "rip6", AF_INET6);
    NSMutableArray *rip6 = [[NSMutableArray alloc] initWithArray: allItems];
    [structuredReturn setObject: rip6 forKey:@"RIP6"];

    udp_done = 0;
    tcp_done = 0;
    
    protopr(IPPROTO_ICMPV6, "icmp6", AF_INET6);
    NSMutableArray *icmp6 = [[NSMutableArray alloc] initWithArray: allItems];
    [structuredReturn setObject: icmp6 forKey:@"IP6.ICMP"];
    
//    NSLog(@"RET: %@", structuredReturn);
//    
    return structuredReturn;
}
- (NSArray *) getUDPConnections{
//    return [self protopr:IPPROTO_UDP name:"udp" af:AF_INET];
    return nil;
}
@end
