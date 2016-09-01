//
//  DeviceTransferCounter.m
//  Device Inspector
//
//  Created by Rogerio Tomio Hirooka on 3/19/12.
//  Copyright (c) 2012 Lirum Labs T Sistemas. All rights reserved.
//

#import "DeviceTransferCounter.h"
#import "DataLenghtManager.h"

#import <arpa/inet.h>
#import <ifaddrs.h>
#import <sys/types.h>
#import <sys/socket.h>

#import <net/if.h>
#import <net/if_dl.h>

@implementation DeviceTransferCounter

+ (NSMutableDictionary *)getCachedDataCounters : (int) refresh
{
    static NSMutableDictionary *cached;
    if (refresh == 1|| cached == nil)
        cached = [self getDataCounters];

    return cached;
}

+ (NSMutableDictionary *)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    NSMutableDictionary *arr = [[NSMutableDictionary alloc] init];
    
    double WiFiSent = 0;
    double WiFiReceived = 0;
    double WWANSent = 0;
    double WWANReceived = 0;
    
    NSString *name=[[NSString alloc]init];
    
    success = getifaddrs(&addrs) == 0;
    if (success) 
    {
        cursor = addrs;
        while (cursor != NULL) 
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            //NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN 
            
            if (cursor->ifa_addr->sa_family == AF_LINK) 
            {
                if ([name hasPrefix:@"en"]) 
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
//                    NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
//                    NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                
                if ([name hasPrefix:@"pdp_ip"]) 
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
//                    NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
//                    NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        [arr setObject:
         [DataLenghtManager bytesToMultipleString: WiFiSent
                                       targetUnit: 1.0f
                                 numberOfDecimals: 0] forKey:@"WIFI.SENT"];
        [arr setObject:
         [DataLenghtManager bytesToMultipleString: WiFiReceived
                                       targetUnit: 1.0f
                                 numberOfDecimals: 0] forKey:@"WIFI.RECEIVED"];
        [arr setObject:
         [DataLenghtManager bytesToMultipleString: WWANSent
                                       targetUnit: 1.0f
                                 numberOfDecimals: 0] forKey:@"WWAN.SENT"];
        [arr setObject:
         [DataLenghtManager bytesToMultipleString: WWANReceived
                                       targetUnit: 1.0f
                                 numberOfDecimals: 0] forKey:@"WWAN.RECEIVED"];
        
        // numeric values
        [arr setObject: [NSNumber numberWithDouble: WiFiSent]       forKey:@"WIFI.SENT.NUMERIC"];
        [arr setObject: [NSNumber numberWithDouble: WiFiReceived]   forKey:@"WIFI.RECEIVED.NUMERIC"];
        [arr setObject: [NSNumber numberWithDouble: WWANSent]       forKey:@"WWAN.SENT.NUMERIC"];
        [arr setObject: [NSNumber numberWithDouble: WWANReceived]   forKey:@"WWAN.RECEIVED.NUMERIC"];
    }
    freeifaddrs(addrs);

    return arr;
    
//    return [NSArray arrayWithObjects:[NSNumber numberWithInt:WiFiSent], [NSNumber numberWithInt:WiFiReceived],[NSNumber numberWithInt:WWANSent],[NSNumber numberWithInt:WWANReceived], nil];
}


@end
