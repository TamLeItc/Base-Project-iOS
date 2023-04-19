//
//  BaseProject-Bridging-Header.h
//  BaseProject
//
//  Created by Tam Le on 10/22/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_INLINE NSException * _Nullable tryBlock(void(^_Nonnull tryBlock)(void)) {
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        NSLog(@"tryBlock: %@", exception);
        return exception;
    }
    return nil;
}

NS_INLINE NSException * _Nullable tryCatchBlock(void(^_Nonnull tryBlock)(void), void(^_Nonnull catchBlock)(void)) {
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        NSLog(@"tryCatchBlock: %@", exception);
        catchBlock();
    }
    return nil;
}
