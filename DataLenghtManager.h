//
//  DataLenghtManager.h
//  Device Inspector
//
//  Created by Rogerio Tomio Hirooka on 12/22/11.
//  Copyright (c) 2011 Lirum Labs T Sistemas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataLenghtManager : NSObject

extern float const AUTO;
extern float const BYTES;
extern float const KB;
extern float const MB;
extern float const GB;
extern float const TB;
extern float const PB;

+(NSString *)bytesToMultipleString: (float)input targetUnit:(float)unit numberOfDecimals:(int)decimals;
+(NSString *)bytesToMultipleString: (float)input targetUnit:(float)unit numberOfDecimals:(int)decimals breakUnit:(BOOL)breakUnit;
+(NSString *)decimalString: (float)input numberOfDecimals:(int)decimals;
+(NSString *) multipleString: (float)input
                  targetUnit: (float)unit
            numberOfDecimals: (int)decimals
                  unitSymbol: (NSString *)unitSymbol;

//+(float)getStorageInfo:(BOOL)totalSize;


@end
