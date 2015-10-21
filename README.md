# NSURLProtocolDemo

NSURLProtocol can be treated as a middle-man in URL Loading process. 
When an NSURLSession, NSURLConnection, or NSURLDownload object initiates a connection for an NSURLRequest, the URL Loading system consults each of the registered NSURLProtocol classes in the reverse order of their registration.  

This is a working example of using subclass NSURLProtocol with NSURLConnection and ASI individually. 
