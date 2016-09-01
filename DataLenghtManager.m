//
//  DataLenghtManager.m
//  Device Inspector
//
//  Created by Rogerio Tomio Hirooka on 12/22/11.
//  Copyright (c) 2011 Lirum Labs T Sistemas. All rights reserved.
//

#import "DataLenghtManager.h"

@implementation DataLenghtManager

float const AUTO   = 0.0f;
float const BYTES  = 1.0f;
float const KB     = 1024.0f;
float const MB     = 1048576.0f;
float const GB     = 1073741824.0f;
float const TB     = 1099511627776.0f;
float const PB     = 1125899906842624.0f;

float const Un     = 1.0f;
float const KUn    = 1000.0f;
float const MUn    = 1000000.0f;
float const GUn    = 1000000000.0f;
float const TUn    = 1000000000000.0f;
float const PUn    = 1000000000000000.0f;

static NSNumberFormatter *formatter = nil;

+(NSNumberFormatter *) getFormatter
{
    if (!formatter)
    {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setGroupingSize:3];
        [formatter setUsesGroupingSeparator:YES];
    }
    
    return formatter;
}

+(NSString *)bytesToMultipleString: (float)input
                        targetUnit: (float)unit
                  numberOfDecimals: (int)decimals
{
    return [self bytesToMultipleString:input
                            targetUnit:unit
                      numberOfDecimals:decimals
                             breakUnit:FALSE];
}

+(NSString *)bytesToMultipleString: (float)input
                        targetUnit: (float)unit
                  numberOfDecimals: (int)decimals
                         breakUnit: (BOOL)breakUnit
{
    NSString *retVal = 
           [self bytesToMultipleString:input
                            targetUnit:unit
                      numberOfDecimals:decimals
                             breakUnit:breakUnit
                             ommitUnit:FALSE];
    return retVal;
}

+(NSString *)bytesToMultipleString: (float)input
                        targetUnit: (float)unit
                  numberOfDecimals: (int)decimals
                         breakUnit: (BOOL)breakUnit
                         ommitUnit: (BOOL)ommitUnit
{
    float preResult = 0;
    if (unit == AUTO)
    {
        if (input < KB) unit = BYTES;
        else if (input < MB) unit = KB;
        else if (input < GB) unit = MB;
        else if (input < TB) unit = GB;
        else if (input < PB) unit = TB;
        else unit = PB;
    }
    
    NSString *stringUnit;
    if (unit == BYTES) stringUnit = @"bytes";
    else if (unit == KB) stringUnit = @"KB";
    else if (unit == MB) stringUnit = @"MB";
    else if (unit == GB) stringUnit = @"GB";
    else if (unit == TB) stringUnit = @"TB";
    else if (unit == PB) stringUnit = @"PB";
    
    preResult = input / unit;
    
    if (unit == BYTES) decimals = 0;
    NSNumberFormatter *form = [self getFormatter];
    [form setMinimumFractionDigits:decimals];
    [form setMaximumFractionDigits:decimals];

    NSString *format1 = @"%@ %@";
    NSString *format2 = @"%@\n%@";
    
    if (ommitUnit) stringUnit = @"";
    
    return [NSString stringWithFormat: breakUnit ? format2 : format1,
            [form stringFromNumber:[NSNumber numberWithFloat:preResult]], stringUnit];
}


+(NSString *) multipleString: (float)input
                  targetUnit: (float)unit
            numberOfDecimals: (int)  decimals
                  unitSymbol: (NSString *)unitSymbol
{
    float preResult = 0;
    if (unit == AUTO)
    {
        if (input < KUn) unit = Un;
        else if (input < MUn) unit = KUn;
        else if (input < GUn) unit = MUn;
        else if (input < TUn) unit = GUn;
        else if (input < PUn) unit = TUn;
        else unit = PUn;
    }
    
    NSString *stringUnit;
    if (unit == Un) stringUnit = @"";
    else if (unit == KUn) stringUnit = @"K";
    else if (unit == MUn) stringUnit = @"M";
    else if (unit == GUn) stringUnit = @"G";
    else if (unit == TUn) stringUnit = @"T";
    else if (unit == PUn) stringUnit = @"P";
    
    preResult = input / unit;
    
    if (unit == KUn) decimals = 0;
    NSNumberFormatter *form = [self getFormatter];
    [form setMinimumFractionDigits:decimals];
    [form setMaximumFractionDigits:decimals];
    
    NSString *format1 = @"%@ %@%@";
    
    return [NSString stringWithFormat: format1,
            [form stringFromNumber:[NSNumber numberWithFloat:preResult]],
            stringUnit,
            unitSymbol];
}


+(NSString *)decimalString: (float)input numberOfDecimals:(int)decimals
{
    NSNumberFormatter *form = [self getFormatter];
    [form setMinimumFractionDigits:decimals];
    [form setMaximumFractionDigits:decimals];
    
    return [NSString stringWithFormat:@"%@",
            [form stringFromNumber:[NSNumber numberWithFloat:input]]];
}

@end
