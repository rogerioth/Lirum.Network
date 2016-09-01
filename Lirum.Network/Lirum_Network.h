//
//  Lirum_Network.h
//  Lirum.Network
//
//  Created by Rogerio Hirooka on 2/26/16.
//  Copyright © 2016 Lirum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lirum_Network : NSObject

    + (NSString *) commTest;
    - (NSMutableDictionary *) getConnections;
    + (NSString *) getWifiIP;
    + (NSString *) getWWanIP;
    + (NSMutableDictionary *)getCachedDataCounters : (int) refresh;
    + (NSMutableDictionary *)getDataCounters;
    + (void) refreshNetworkElements;
    + (void) initializeNetworkElements;

@end
