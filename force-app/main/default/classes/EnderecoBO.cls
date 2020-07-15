global class EnderecoBO {

    private static final EnderecoBO instance = new EnderecoBO();

    public static EnderecoBO getInstance(){
        return instance;
    }

    public static void formatarCep(List<Endereco__c> lstEndereco, Map<Id,Endereco__c> oldMapEnderecos){
        oldMapEnderecos = oldMapEnderecos == null ? new Map<Id,Endereco__c>() : oldMapEnderecos; 
        for (Endereco__c endereco : lstEndereco) {
            Endereco__c oldEndereco = oldMapEnderecos.get(endereco.Id);
            if(!String.isBlank(endereco.cep__c) && endereco.cep__c != oldEndereco.cep__c)
                endereco.cep__c = endereco.cep__c.replace('-','');
        }
    }

    @AuraEnabled
    public static void preencherEndereco(String enderecoId){
        Endereco__c endereco = EnderecoDAO.getEnderecoPorId(enderecoId);
        String cep = endereco.CEP__c;

        EnderecoServiceTO.BuscaCepTO res = BuscaCEPService.buscaCEP(cep);
        if (res != null) {
            endereco.Bairro__c = res.bairro;
            endereco.Logradouro__c = res.logradouro;
            endereco.Municipio__c = res.localidade;
            endereco.Estado__c = res.uf;
            update endereco;
        }
    }

    @AuraEnabled
    public static void preencherGeolocalizao(String enderecoId){
        Endereco__c endereco = EnderecoDAO.getEnderecoPorId(enderecoId);
        String enderecoCompleto = endereco.EnderecoCompleto__c;

        EnderecoServiceTO.GeocodeTO res = GeocodeService.getInstance().getLatLong(enderecoCompleto);
        if (res != null) {
            endereco.Geolocalizacao__latitude__s  = res.results[0].geometry.location.lat;
            endereco.Geolocalizacao__longitude__s = res.results[0].geometry.location.lng;
            update endereco;
        }
    }
}
