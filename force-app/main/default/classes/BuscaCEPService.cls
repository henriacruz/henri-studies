public with sharing class BuscaCEPService {

    private static final BuscaCEPService instance = new BuscaCEPService();

    public static BuscaCEPService getInstance() {
        return instance;
    } 

    public static EnderecoServiceTO.BuscaCepTO buscaCEP(String cep) {
        EnderecoServiceTO.BuscaCepTO retorno = new EnderecoServiceTO.BuscaCepTO();
        String cepFormatado = cep.replace('-','');

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        req.setEndpoint('https://viacep.com.br/ws/'+cepFormatado+'/json/');
        req.setMethod('GET');
        req.setCompressed(true);

        try {
            res = http.send(req);
            retorno = (EnderecoServiceTO.BuscaCepTO)JSON.deserialize(res.getBody(), EnderecoServiceTO.BuscaCepTO.class);

        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
        return retorno;
    }
}
