# NSURLProtocolDemo

NSURLProtocol can be treated as a middle-man in URL Loading process. 
When an NSURLSession, NSURLConnection, or NSURLDownload object initiates a connection for an NSURLRequest, the URL Loading system consults each of the registered NSURLProtocol classes in the reverse order of their registration.  

This is a working example of subclassing NSURLProtocol with NSURLConnection and ASI individually.   

If you can read Mandarin, here is a post written by me about more details of NSURLProtocol and some tips on subclassing it.
[http://www.cnblogs.com/mindyme/p/4898224.html](http://www.cnblogs.com/mindyme/p/4898224.html)
