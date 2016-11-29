//
//  FEWebView.h
//  Pet
//
//  Created by ios on 16/4/1.
//  Copyright © 2016年 Yourpet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FEWebView;

@protocol FEWebViewDelegate <NSObject>

@optional

- (BOOL)webView:(FEWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(FEWebView *)webView;
- (void)webViewDidFinishLoad:(FEWebView *)webView;
- (void)webView:(FEWebView *)webView didFailLoadWithError:(NSError *)error;

@end


@interface FEWebView : UIView

@property (nonatomic, weak) id <FEWebViewDelegate> delegate;

@property (nonatomic, readonly, strong) UIScrollView *scrollView;

@property (nonatomic, readonly, getter=canGoBack) BOOL canGoBack;
@property (nonatomic, readonly, getter=canGoForward) BOOL canGoForward;
@property (nonatomic, readonly, getter=isLoading) BOOL loading;

@property (nonatomic, assign) BOOL scalesPageToFit;

@property (nonatomic, readonly, copy) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView;

- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

- (void)reload;
- (void)stopLoading;

- (void)goBack;
- (void)goForward;

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;

@end
