//
//  DeviceTransferCounter.h
//  Device Inspector
//
//  Created by Rogerio Tomio Hirooka on 3/19/12.
//  Copyright (c) 2012 Lirum Labs T Sistemas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceTransferCounter : NSObject

+ (NSMutableDictionary *)getCachedDataCounters : (int) refresh;
+ (NSMutableDictionary *)getDataCounters;

@end
