//
//  MURLProtocolWithASI.m
//  URLLoadingSystem
//
//  Created by Mindy on 15/10/21.
//

#import "MURLProtocolWithASI.h"
#import "ASIHTTPRequest.h"

@interface MURLProtocolWithASI()<ASIHTTPRequestDelegate>
@property (nonatomic, strong) ASIHTTPRequest *aRequest;
@end

@implementation MURLProtocolWithASI

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:@"http"]) {
        return YES;
    }
    return NO;
}


+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    self.aRequest = [[ASIHTTPRequest alloc] initWithURL:self.request.URL];
    self.aRequest.delegate = self;
    [self buildRequest:self.aRequest];

    
    __weak ASIHTTPRequest* _request = self.aRequest;
    __weak MURLProtocolWithASI* _protocol = self;
    [self.aRequest setHeadersReceivedBlock:^(NSDictionary* responseHeaders){
        int statusCode = _request.responseStatusCode;
        if(statusCode != 302 && statusCode != 301){
            [[_protocol client] URLProtocol:_protocol didReceiveResponse:[[NSHTTPURLResponse alloc] initWithURL:_protocol.request.URL statusCode:_request.responseStatusCode HTTPVersion:@"HTTP/1.0" headerFields:responseHeaders] cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        }
    }];
    
    [self.aRequest setCompletionBlock:^{
        NSData *data = [_request responseData];
        if (data){
            [[_protocol client] URLProtocol:_protocol didLoadData:data];
        }
        [[_protocol client] URLProtocolDidFinishLoading:_protocol];
    }];
    
    [self.aRequest setFailedBlock:^{
        NSData *data = [_request responseData];
        if (data){
            [[_protocol client] URLProtocol:_protocol didLoadData:data];
        }

        [[_protocol client] URLProtocol:_protocol didFailWithError:[NSError errorWithDomain:@"www.baidu.com" code:_request.responseStatusCode userInfo:nil]];
    }];
    
    [self.aRequest startAsynchronous];
    
}

- (void)stopLoading
{
    [self.aRequest clearDelegatesAndCancel];
}


- (void)buildRequest:(ASIHTTPRequest*)asiRequest{
    for (NSString *headerFieldName in self.request.allHTTPHeaderFields.allKeys)
    {
        [asiRequest addRequestHeader:headerFieldName value:[self.request.allHTTPHeaderFields valueForKey:headerFieldName]];
    }
    
    [asiRequest setRequestMethod:self.request.HTTPMethod];
    if (self.request.HTTPBody){
        [asiRequest appendPostData:self.request.HTTPBody];
    }
}

#pragma mark - ASIHTTPRequestDelegate
-(void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL{
    NSMutableURLRequest* redirectableRequest = [[NSMutableURLRequest alloc]initWithURL:[newURL copy]];
    redirectableRequest.allHTTPHeaderFields = [self.request allHTTPHeaderFields];

    [[self client] URLProtocol:self
        wasRedirectedToRequest:redirectableRequest
              redirectResponse:[[NSHTTPURLResponse alloc]
                                initWithURL:request.url
                                statusCode:request.responseStatusCode
                                HTTPVersion:@"HTTP/1.0"
                                headerFields:request.responseHeaders]];
    
    //DO NOT call [request redirectToURL:newURL] to resume loading.
    //A new MURLProtocolWithASI instance will be created for the new URL
    [request markAsFinished];
}

@end
