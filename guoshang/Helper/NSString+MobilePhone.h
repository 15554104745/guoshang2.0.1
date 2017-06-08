//
//  NSString+MobilePhone.h
//  guoshang
//
//  Created by Rechied on 16/9/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MobilePhone)
- (BOOL)isMobileNumberOrTelNumber;
- (BOOL)isReallyMobileNumber;
- (BOOL)isCorrect;
@end
