//
//  DHInet.h
//  InetTest
//
//  Created by Rogerio Tomio Hirooka on 12/22/11.
//  Copyright (c) 2011 Lirum Labs T Sistemas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHInet : NSObject

+ (NSMutableDictionary *) getTCPConnections;
- (NSArray *) getUDPConnections;

NSString *
customInet6print(struct in6_addr *in6, int port, char *proto, int numeric);

char *
inetname(struct in_addr *inp);

void
inetprint(struct in_addr *in, int port, char *proto, int numeric_port);

NSString *
customInetPrint(struct in_addr *in, int port, char *proto, int numeric_port);

void
protopr(u_long proto,		/* for sysctl version we pass proto # */
        char *name, int af);


@end
