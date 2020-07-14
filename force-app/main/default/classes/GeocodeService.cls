public class GeocodeService {
    private static final GeocodeService instance = new GeocodeService();
    public static String API_KEY = 'validKey';

    public static GeocodeService getInstance() {
        return instance;
    } 

    public EnderecoServiceTO.GeocodeTO getLatLong(String address){
        address = EncodingUtil.urlEncode(address, 'UTF-8');
        
        EnderecoServiceTO.GeocodeTO retorno = new EnderecoServiceTO.GeocodeTO();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&key=' + API_KEY);
        req.setMethod('GET');
        req.setTimeout(5000);
        
        try {
            res = http.send(req);
            retorno = (EnderecoServiceTO.GeocodeTO)JSON.deserialize(res.getBody(), EnderecoServiceTO.GeocodeTO.class);
            System.debug('Retorno da API: '+retorno);
            
        } catch (System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
                
        return retorno;
    }

}
