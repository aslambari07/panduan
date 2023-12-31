/**
 @file          NSString+Branch.m
 @package       Branch-SDK
 @brief         NSString Additions

 @author        Edward Smith
 @date          February 2017
 @copyright     Copyright © 2017 Branch. All rights reserved.
*/

#import "NSString+Branch.h"

__attribute__((constructor)) void BNCForceNSStringCategoryToLoad(void) {
    //  Nothing here, but forces linker to load the category.
}

@implementation NSString (Branch)

- (BOOL) bnc_isEqualToMaskedString:(NSString*_Nullable)string {
    // Un-comment for debugging:
    // NSLog(@"bnc_isEqualToMaskedString self/string:\n%@\n%@.", self, string);
    if (!string) return NO;
    if (self.length != string.length) return NO;
    for (NSUInteger idx = 0; idx < self.length; idx++) {
        unichar p = [self characterAtIndex:idx];
        unichar q = [string characterAtIndex:idx];
        if (q != '*' && p != q) return NO;
    }
    return YES;
}

@end
