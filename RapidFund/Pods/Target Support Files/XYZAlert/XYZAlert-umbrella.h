#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "XYZAlertDispatch.h"
#import "XYZAlertProtocol.h"
#import "XYZAlertQueue.h"
#import "UIViewController+XYZAlert.h"
#import "XYZAlertView.h"
#import "XYZSystemAlertView.h"

FOUNDATION_EXPORT double XYZAlertVersionNumber;
FOUNDATION_EXPORT const unsigned char XYZAlertVersionString[];

