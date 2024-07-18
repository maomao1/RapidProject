//
//  WKWebViewJavascriptBridge+Fix.m
//  JSBridgeIOSSwift
//
//  Created by wangwei on 2021/3/27.
//

#import "WKWebViewJavascriptBridge+Fix.h"
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge_JS.h"
#import "WKWebViewJavascriptBridge.h"

@interface WKWebViewJavascriptBridge ()

- (void)_setupInstance:(WKWebView*)webView;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
@implementation WKWebViewJavascriptBridge (Fix)

+ (instancetype)bridgeForWebView:(WKWebView*)webView
{
    WKWebViewJavascriptBridge* bridge = [[self alloc] init];
    [bridge _setupInstance: webView];
    injectJavascriptFile(webView);
    [bridge reset];
    return bridge;
}


#pragma clang diagnostic pop

void injectJavascriptFile(WKWebView* webView)
{
    WKUserScript *javascriptBridge_js = [[WKUserScript alloc] initWithSource:WebViewJavascriptBridge_js() injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly: YES];
    [webView.configuration.userContentController addUserScript:javascriptBridge_js];
    
    NSString* bridge_loaded_command = [NSString stringWithFormat:@"\
                                       var bridgeLoadedIframe = document.createElement('iframe');\
                                       bridgeLoadedIframe.style.display = 'none';\
                                       bridgeLoadedIframe.src = '%@://%@';\
                                       document.documentElement.appendChild(bridgeLoadedIframe);\
                                       ", kOldProtocolScheme, kBridgeLoaded];
    WKUserScript *javascriptBridge_loaded_js = [[WKUserScript alloc] initWithSource:bridge_loaded_command injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly: YES];
    [webView.configuration.userContentController addUserScript:javascriptBridge_loaded_js];
}

@end
