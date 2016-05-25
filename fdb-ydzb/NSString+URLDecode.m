//
//  NSString+URLDecode.m
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/10/8.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

#import "NSString+URLDecode.h"

@implementation NSString (URLDecode)

-(NSString *)URLDecode

{
    
    NSString *result = [(NSString*)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (NSString *)stringByDecodingURLFormat
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}


- (NSDictionary*)parsePairs:(NSString*)urlStr

{
    
    NSRange r = [urlStr rangeOfString:@"="];
    if(r.length == 0)
    {
        return nil;
    }
    
    //Here I'm getting an error
    
    NSString* token = [[urlStr substringFromIndex:r.location + 1 ] URLDecode];
    
    NSCharacterSet* objectMarkers;
    objectMarkers = [NSCharacterSet characterSetWithCharactersInString:@"{}"];
    token = [token stringByTrimmingCharactersInSet:objectMarkers];
    
    NSError* regexError;
    NSMutableDictionary* pairs = [NSMutableDictionary dictionaryWithCapacity:10];
    
    NSRegularExpression* regex;
    regex = [NSRegularExpression regularExpressionWithPattern:@"\"([^\"]*)\":\"([^\"]*)\""
                                                      options:0
                                                        error:&regexError];
    NSArray* matches = [regex matchesInString:token
                                      options:0
                                        range:NSMakeRange(0, token.length)];
    
    for(NSTextCheckingResult* result in matches)
    {
        for(int n = 1; n < [result numberOfRanges]; n += 2)
        {
            NSRange r = [result rangeAtIndex:n];
            if(r.length > 0)
            {
                NSString* name = [token substringWithRange:r];
                
                r = [result rangeAtIndex:n + 1];
                if(r.length > 0)
                {
                    NSString* value = [token substringWithRange:r];
                    
                    [pairs setObject:value forKey:name];
                }
            }
        }
    }
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"\"([^\"]*)\":([0-9]*)"
                                                      options:0
                                                        error:&regexError];
    matches = [regex matchesInString:token
                             options:0
                               range:NSMakeRange(0, token.length)];
    
    for(NSTextCheckingResult* result in matches)
    {
        for(int n = 1; n < [result numberOfRanges]; n += 2)
        {
            NSRange r = [result rangeAtIndex:n];
            if(r.length > 0)
            {
                NSString* name = [token substringWithRange:r];
                
                r = [result rangeAtIndex:n + 1];
                if(r.length > 0)
                {
                    NSString* value = [token substringWithRange:r];
                    NSNumber* number = [NSNumber numberWithInt:[value intValue]];
                    
                    [pairs setObject:number forKey:name];
                }
            }
        }
    }
    
    return pairs;
}

@end
