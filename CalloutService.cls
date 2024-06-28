public with sharing class CalloutService {
    private static final String baseURL;
    private static String accessToken;

    static {
        apiJavaConnection__mdt api = [SELECT baseURL__c, email__c, passwd__c FROM apiJavaConnection__mdt LIMIT 1];
        baseURL = api.baseURL__c;

        authenticate(api.email__c, api.passwd__c);
    }

    public static HttpResponse callout(String endpoint, String method, String body) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(baseURL + endpoint);
        req.setMethod(method);
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setBody(body);
        Http http = new Http();
        req.setTimeout(20000);
        HttpResponse res = http.send(req);
        return res;
    }

    private static void authenticate(String email, String passwd) {
        // Header para autenticação "BASIC"
        // String credentials = EncodingUtil.base64Encode(Blob.valueOf(usuario + ':' + senha));
        // req.setHeader('Authorization', 'Basic ' + credentials);
        String user = '{' +
                      '"email": "' + email + '",' +
                      '"senha": "' + passwd + '"' +
                      '}';

        String endpoint = baseURL + '/usuarios/login';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        req.setBody(user);
        Http http = new Http();
        HttpResponse res = http.send(req);

        if(res.getStatusCode() ==  200){
            Map<String, Object> resBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            accessToken = (String)resBody.get('token');
            System.debug('Login realizado com sucesso');
        }else {
            throw new CalloutException('Falha na autenticação. Status Code: ' + res.getStatusCode() + ' Response: ' + res.getBody());
        }
    }
}

// Essa arquitetura de login funcionad perfeitamente, ela executa o login apenas uma vez por contexto de transação,
// ou seja ela não faz o login mais de uma vez no mesmo contexto de transação, isso se da por que a cada contexto de 
// transação todo estado da aplicação é resetado, a transação começa com um 'estado limpo'