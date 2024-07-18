//
//  WKWebViewJavascriptBridge+Fix.h
//  JSBridgeIOSSwift
//
//  Created by wangwei on 2021/3/27.
//

#import "WKWebViewJavascriptBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKWebViewJavascriptBridge (Fix)

+ (instancetype)bridgeForWebView:(WKWebView*)webView;

@end

NS_ASSUME_NONNULL_END
