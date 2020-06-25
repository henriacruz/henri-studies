public with sharing class EnderecoDAO {
    
    public static Endereco__c getEnderecoPorId(Id enderecoId){
        List<Endereco__c> enderecos = getEnderecoPorId(new Set<Id>{enderecoId});
        if(enderecos.size() == 0){
            return null;
        }
        return enderecos.get(0);
    }

    public static List<Endereco__c> getEnderecoPorId(Set<Id> enderecoIds){
        return [SELECT
                    Id,
                    Name,
                    Ativo__c,
                    Account__c,
                    Bairro__c,
                    CEP__c,
                    Complemento__c,
                    Estado__c,
                    EnderecoCompleto__c,
                    Geolocalizacao__c,
                    Logradouro__c,
                    Municipio__c,
                    Numero__c,
                    Pais__c,
                    TipoEndereco__c
                FROM
                    Endereco__c
                WHERE
                    Id IN: enderecoIds];
    }
}
