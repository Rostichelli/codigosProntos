public with sharing class MultiRequestMock implements HttpCalloutMock {
    Map<String, HttpCalloutMock> requests;

    public MultiRequestMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    public HTTPResponse respond(HTTPRequest req) {
	HttpCalloutMock mock = requests.get(req.getEndpoint());
    for (String key : requests.keySet()) {
        System.debug('Endpoint: ' + key);
    }

	    if (mock != null) {
	        return mock.respond(req);
            } else {
     		throw new CalloutException('HTTP callout not supported for test methods');
	    }
    }

    public void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    }
}