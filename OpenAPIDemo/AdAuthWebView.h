//
//  AdAuthWebView.h
//  OpenAPIDemo
//
//  Created by my on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdAuthWebView;

@protocol AdAuthoWebViewDelegate <NSObject>

- (void)authorizeWebView:(AdAuthWebView *)webView didReceiveAuthorizeCode:(NSString *)code;

@end

@interface AdAuthWebView : UIView<UIWebViewDelegate>
{
    UIView *panelView;
    UIView *containerView;
    UIActivityIndicatorView *indicatorView;
	UIWebView *webView;
    
    UIInterfaceOrientation previousOrientation;
    
    id<AdAuthoWebViewDelegate> delegate;
}

@property (nonatomic, assign) id<AdAuthoWebViewDelegate> delegate;

- (void)loadRequestWithURL:(NSURL *)url;

- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated;

@end
