//
//  MURLProtocol.m
//  URLLoadingSystem
//
//  Created by Mindy on 15/10/21.
//

#import "MURLProtocol.h"

static NSString *MURLHeaderField = @"M-Header";

@interface MURLProtocol() <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation MURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSURL *url = request.URL;
    if([url.scheme isEqualToString:@"http"] && [request valueForHTTPHeaderField:MURLHeaderField] == nil){
        return YES;
    }
    
    return  NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client{
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
}


- (void)startLoading{
    NSMutableURLRequest *myRequest = [self.request mutableCopy];
    [myRequest setValue:@"" forHTTPHeaderField:MURLHeaderField];
    self.connection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self startImmediately:YES];
}

- (void)stopLoading{
    [self.connection cancel];
}

- (void)dealloc{
    
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self.client URLProtocolDidFinishLoading:self];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self.client URLProtocol:self didFailWithError:error];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{;
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (nullable NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(nullable NSURLResponse *)response{
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        if ([HTTPResponse statusCode] == 301 || [HTTPResponse statusCode] == 302)
        {
            
            NSMutableURLRequest *mutableRequest = [request mutableCopy];
            [mutableRequest setURL:[NSURL URLWithString:[[HTTPResponse allHeaderFields] objectForKey:@"Location"]]];
            request = [mutableRequest copy];
            
            [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
        }
    }
    
    return request;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.client URLProtocol:self didLoadData:data];
}
@end
