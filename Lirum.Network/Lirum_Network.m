//
//  Lirum_Network.m
//  Lirum.Network
//
//  Created by Rogerio Hirooka on 2/26/16.
//  Copyright © 2016 Lirum. All rights reserved.
//

#import "Lirum_Network.h"
#import "DeviceTransferCounter.h"

#import "DHInet.h"
#import "DNSQuery.h"

#import "DeviceIP.h"


@implementation Lirum_Network

static NSString *wifiIP;
static NSString *wifiMAC;
static NSString *wwanIP;

static NSString *externalIP;

+ (NSString *) commTest {
    return @"OK";
}

- (NSMutableDictionary *) getConnections {
    return [DHInet getTCPConnections];
}

+ (NSString *) getWifiIP {
    return wifiIP;
}

+ (NSString *) getWWanIP {
    return wwanIP;
}

+ (NSMutableDictionary *)getCachedDataCounters : (int) refresh {
    return [DeviceTransferCounter getCachedDataCounters: refresh];
}

+ (NSMutableDictionary *)getDataCounters {
    return [DeviceTransferCounter getDataCounters];
}

+(void) refreshNetworkElements {
    InitAddresses();
    
    FreeAddresses();
    // retrieves wifi and wwan ip and mac information
    //InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    int i;
    
    for (i=0; i<MAXADDRS; ++i)
    {
        static unsigned long localHost = 0x7F000001;            // 127.0.0.1
        unsigned long theAddr;
        
        theAddr = ip_addrs[i];
        
        if (theAddr == 0) break;
        if (theAddr == localHost) continue;
        
        //decided what adapter you want details for
        if (strncmp(if_names[i], "en", 2) == 0) {
            wifiIP = [NSString stringWithFormat:@"%s", ip_names[i]];
            wifiMAC = [NSString stringWithFormat:@"%s", hw_addrs[i]];
        }
        else if (strncmp(if_names[i], "pdp", 3) == 0) {
            wwanIP = [NSString stringWithFormat:@"%s", ip_names[i]];
        }
    }
    
}

+(void) initializeNetworkElements
{
    // retrieves wifi and wwan ip and mac information
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    int i;
    
    for (i=0; i<MAXADDRS; ++i) {
        static unsigned long localHost = 0x7F000001;            // 127.0.0.1
        unsigned long theAddr;
        
        theAddr = ip_addrs[i];
        
        if (theAddr == 0) break;
        if (theAddr == localHost) continue;
        
        //decided what adapter you want details for
        if (strncmp(if_names[i], "en", 2) == 0) {
            wifiIP = [NSString stringWithFormat:@"%s", ip_names[i]];
            wifiMAC = [NSString stringWithFormat:@"%s", hw_addrs[i]];
        }
        else if (strncmp(if_names[i], "pdp", 3) == 0) {
            wwanIP = [NSString stringWithFormat:@"%s", ip_names[i]];
        }
    }
}

@end
