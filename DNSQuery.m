//
//  DNS.m
//  InetTest
//
//  Created by Rogerio Tomio Hirooka on 12/22/11.
//  Copyright (c) 2011 Lirum Labs T Sistemas. All rights reserved.
//

//#import <Foundation/Foundation.h>
//

#import "DNSQuery.h"

#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/nameser.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <resolv.h>
#include <errno.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include <dns_util.h>


@implementation DNSQuery : NSObject

//takes a string like 1.1.168.192.in-addr.arpa and turns it into the hostname
- (char *) _reverseDns: (const char*) arpaPoint
{
    int len = -1;
    char buffer[kBufLen];
    res_init();
    
    int queryType = T_PTR; /* domain name pointer */
    int arpanet = C_IN; /* the arpa internet = 1*/
    len = res_query(arpaPoint, arpanet, queryType, (u_char *)buffer, kBufLen);
    char *resStr;
    dns_reply_t *reply;
    if (len > 0)
    {
        reply = dns_parse_packet(buffer, len);
        resStr = ((*(reply->answer))->data).PTR->name;
    }
    else
    {
        if (errno)
            fprintf(stderr, "Error, res_query() error value: %d\n", errno);
        if (61 == errno)
            resStr = "Could not connect to DNS";
        else
            resStr = "DNS entry Not Found";
    }
    return resStr;
}

//makes 192.168.1.1 into 1.1.168.192.in-addr.arpa
- (NSString *) makeDNSLookupString: (NSString *)inString
{
    NSString *eachString = @"";
    NSScanner *scanner = [NSScanner scannerWithString:inString];
    NSUInteger scanLocation = 0;
    NSUInteger stringLen = [inString length];
    NSString *outStr = @"";
    while([scanner scanUpToString:@"." intoString:&eachString])
    {
        eachString = [eachString stringByAppendingString:@"."];
        outStr = [eachString stringByAppendingString:outStr];
        scanLocation = [scanner scanLocation];
        if (scanLocation < stringLen)
            [scanner setScanLocation:scanLocation + 1]; // hop the . character
    }
    outStr = [outStr stringByAppendingString:@"in-addr.arpa"];
    return outStr;
}


//- (NSString*)replacePostdata:(NSString *)postStr: (NSString *)user: (NSString *)pass
//{
//    NSString *output = postStr;
//    output = [output stringByReplacingOccurrencesOfString:@":id:" withString: user];
//    output = [output stringByReplacingOccurrencesOfString:@":pass:" withString: pass];
//    return output;
//}

- (NSString *) reverseDNS : (NSString *) ipAddress
{
    if ([ipAddress isEqualToString:@"*"]) return @"-";
    NSString *arpaString = [self makeDNSLookupString: ipAddress];
    //NSLog(@"arpaString = %@", arpaString);
    
    NSString *returnString = [NSString stringWithCString: [self _reverseDns:([arpaString cStringUsingEncoding:NSASCIIStringEncoding])] encoding:NSASCIIStringEncoding];
    
    if ([returnString isEqualToString: @"DNS entry Not Found"]) {
        returnString = ipAddress;
    }
     
    return returnString;
}



- (NSString *) localIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@end
