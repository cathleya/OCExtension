//
//  FEWebView.m
//  Pet
//
//  Created by ios on 16/4/1.
//  Copyright © 2016年 Yourpet. All rights reserved.
//

#import "FEWebView.h"
@import WebKit;

#define IOS9_OR_LATER	([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending)

@interface FEWebView()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, assign) BOOL usingUIWebView;
@property (nonatomic, strong) id    realWebView;
@end

@implementation FEWebView
@synthesize scalesPageToFit = _scalesPageToFit;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame usingUIWebView:NO];
}

- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _usingUIWebView = usingUIWebView;
        [self initSelf];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_realWebView setFrame:self.bounds];
}

-(void)initSelf
{
    Class wkWebView = NSClassFromString(@"WKWebView");
    if(IOS9_OR_LATER && wkWebView && self.usingUIWebView == NO)
    {
        [self initWKWebView];
        _usingUIWebView = NO;
    }
    else
    {
        [self initUIWebView];
        _usingUIWebView = YES;
    }
    
    self.scalesPageToFit = YES;
    
    [self.realWebView setFrame:self.bounds];
    [self.realWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addSubview:self.realWebView];
}

-(void)initWKWebView
{
    WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
    configuration.preferences = [[WKPreferences alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];
    
    WKWebView* webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
    webView.allowsBackForwardNavigationGestures = YES;
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    
    webView.backgroundColor = [UIColor clearColor];
    
    [webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [webView setAutoresizesSubviews:YES];
    
    _realWebView = webView;
}


-(void)initUIWebView
{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.bounds];
    webView.backgroundColor = [UIColor clearColor];
    webView.delegate = self;
    
    _realWebView = webView;
}


#pragma mark- UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    [self callback_webViewDidFinishLoad];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self callback_webViewDidStartLoad];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self callback_webViewDidFailLoadWithError:error];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL rtn = [self callback_webViewShouldStartLoadWithRequest:request navigationType:navigationType];
    return rtn;
}

#pragma mark- WKNavigationDelegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    BOOL rtn = [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
    if(rtn)
    {
        if(navigationAction.targetFrame == nil)
        {
            [webView loadRequest:navigationAction.request];
        }
        
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self callback_webViewDidStartLoad];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    _title = webView.title;
    [self callback_webViewDidFinishLoad];
}

- (void)webView:(WKWebView *) webView didFailProvisionalNavigation: (WKNavigation *) navigation withError: (NSError *) error
{
    [self callback_webViewDidFailLoadWithError:error];
}

- (void)webView: (WKWebView *)webView didFailNavigation:(WKNavigation *) navigation withError: (NSError *) error
{
    [self callback_webViewDidFailLoadWithError:error];
}

#pragma mark- WKUIDelegate


#pragma mark- CALLBACK IMYVKWebView Delegate

- (void)callback_webViewDidFinishLoad
{
    if([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)])
    {
        [self.delegate webViewDidFinishLoad:self];
    }
}

- (void)callback_webViewDidStartLoad
{
    if([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)])
    {
        [self.delegate webViewDidStartLoad:self];
    }
}

- (void)callback_webViewDidFailLoadWithError:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
    {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}

-(BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType
{
    BOOL resultBOOL = YES;
    if([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)])
    {
        if(navigationType == -1) {
            navigationType = UIWebViewNavigationTypeOther;
        }
        resultBOOL = [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return resultBOOL;
}

#pragma mark- 基础方法
-(UIScrollView *)scrollView
{
    return [self.realWebView scrollView];
}

- (void)loadRequest:(NSURLRequest *)request
{
    if(_usingUIWebView)
    {
        [(UIWebView*)_realWebView loadRequest:request];
    }
    else
    {
        [(WKWebView*)_realWebView loadRequest:request];
    }
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    if(_usingUIWebView)
    {
        [(UIWebView*)_realWebView loadHTMLString:string baseURL:baseURL];
    }
    else
    {
        [(WKWebView*)_realWebView loadHTMLString:string baseURL:baseURL];
    }
}

-(NSURL *)URL
{
    if(_usingUIWebView)
    {
        return [(UIWebView*)_realWebView request].URL;;
    }
    else
    {
        return [(WKWebView*)_realWebView URL];
    }
}
-(BOOL)isLoading
{
    return [self.realWebView isLoading];
}

-(BOOL)canGoBack
{
    return [self.realWebView canGoBack];
}

-(BOOL)canGoForward
{
    return [self.realWebView canGoForward];
}

- (void)goBack
{
    if(_usingUIWebView)
    {
        [(UIWebView*)self.realWebView goBack];
    }
    else
    {
        [(WKWebView*)self.realWebView goBack];
    }
}

- (void)goForward
{
    if(_usingUIWebView)
    {
        [(UIWebView*)self.realWebView goForward];
    }
    else
    {
        [(WKWebView*)self.realWebView goForward];
    }
}
- (void)reload
{
    if(_usingUIWebView)
    {
        [(UIWebView*)self.realWebView reload];
    }
    else
    {
        [(WKWebView*)self.realWebView reload];
    }
}


- (void)stopLoading
{
    [self.realWebView stopLoading];
}


- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler
{
    if(_usingUIWebView)
    {
        NSString* result = [(UIWebView*)self.realWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
        if(completionHandler)
        {
            completionHandler(result,nil);
        }
    }
    else
    {
        [(WKWebView*)self.realWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    }
}

-(NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javaScriptString
{
    if(_usingUIWebView)
    {
        NSString* result = [(UIWebView*)self.realWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
        return result;
    }
    else
    {
        __block NSString* result = nil;
        __block BOOL isExecuted = NO;
        [(WKWebView*)self.realWebView evaluateJavaScript:javaScriptString completionHandler:^(id obj, NSError *error) {
            result = obj;
            isExecuted = YES;
        }];
        
        while (isExecuted == NO) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        return result;
    }
}

-(void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    if(_usingUIWebView)
    {
        UIWebView* webView = _realWebView;
        webView.scalesPageToFit = scalesPageToFit;
    }
    else
    {
        if(_scalesPageToFit == scalesPageToFit)
        {
            return;
        }
        
        WKWebView* webView = _realWebView;
        
        NSString *jScript = @"var meta = document.createElement('meta'); \
        meta.name = 'viewport'; \
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
        var head = document.getElementsByTagName('head')[0];\
        head.appendChild(meta);";
        
        if(scalesPageToFit)
        {
            WKUserScript *wkUScript = [[NSClassFromString(@"WKUserScript") alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
            [webView.configuration.userContentController addUserScript:wkUScript];
        }
        else
        {
            NSMutableArray* array = [NSMutableArray arrayWithArray:webView.configuration.userContentController.userScripts];
            for (WKUserScript *wkUScript in array)
            {
                if([wkUScript.source isEqual:jScript])
                {
                    [array removeObject:wkUScript];
                    break;
                }
            }
            for (WKUserScript *wkUScript in array)
            {
                [webView.configuration.userContentController addUserScript:wkUScript];
            }
        }
    }
    
    _scalesPageToFit = scalesPageToFit;
}

-(BOOL)scalesPageToFit
{
    if(_usingUIWebView)
    {
        return [_realWebView scalesPageToFit];
    }
    else
    {
        return _scalesPageToFit;
    }
}

#pragma mark- 清理
-(void)dealloc
{
    if(_usingUIWebView)
    {
        UIWebView* webView = _realWebView;
        webView.delegate = nil;
    }
    else
    {
        WKWebView* webView = _realWebView;
        webView.UIDelegate = nil;
        webView.navigationDelegate = nil;
        
    }
    
    [_realWebView stopLoading];
    _realWebView = nil;
}

@end
