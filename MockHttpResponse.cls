public class MockHttpResponse implements HttpCalloutMock{
    private Boolean isSuccess;
    private String bodySuccess;
    private String bodyError;
    private Boolean bodyChangeSuccessCode;
    
    public MockHttpResponse(Boolean isSuccess, String bodySuccess, String bodyError){
       this.isSuccess = isSuccess;
       this.bodySuccess = bodySuccess;
       this.bodyError = bodyError;
       this.bodyChangeSuccessCode = false;
    }

    public HTTPResponse respond(HTTPRequest request) {
      HttpResponse response = new HttpResponse();
      response.setHeader('Content-Type', 'application/json');
      if(this.isSuccess){
        response.setStatusCode(200);
        response.setBody(this.bodySuccess);
        response.setStatus('success');
      }else {
        response.setStatusCode(500);
        response.setBody(this.bodyError);
        response.setStatus('Error');
      }
      return response;
  }
}