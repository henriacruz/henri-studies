public with sharing class AccountDAO {
    
    public static Account getAccountsById(Id accountId){
        List<Account> accountList = getAccountsById(new Set<Id>{accountId});
        if(accountList.size() == 0){
            return null;
        }
        return accountList.get(0);
    }

    public static List<Account> getAccountsById(Set<Id> accountIds){
        return [SELECT
                    Id,
                    Name,
                    identificacaoFiscal__c,
                    tipoIdentificacaoFiscal__c,
                    IdentificacaoFiscalSemFormatacao__c
                FROM
                    Account
                WHERE
                    Id IN: accountIds];
    }

    public static List<Account> getAccountsWithIdentifier(Set<String> setIdentificacao){
        return [SELECT
                    Id,
                    Name,
                    identificacaoFiscal__c,
                    tipoIdentificacaoFiscal__c,
                    IdentificacaoFiscalSemFormatacao__c
                FROM
                    Account
                WHERE
                    identificacaoFiscal__c IN : setIdentificacao];
    }

    public static List<Account> getParentAccounts(Set<String> raizCnpj){
        return [SELECT
                    Id,
                    Name,
                    identificacaoFiscal__c,
                    tipoIdentificacaoFiscal__c,
                    IdentificacaoFiscalSemFormatacao__c 
                FROM
                    Account
                WHERE
                    identificacaoFiscal__c LIKE '%0001%'
                    AND tipoIdentificacaoFiscal__c = 'CNPJ'
                    AND IdentificacaoFiscalSemFormatacao__c LIKE : raizCnpj];
    }

    public static List<Account> getSubsidiaryAccounts(Set<String> raizCnpjMatrizes){
        return [SELECT
                    Id,
                    Name,
                    identificacaoFiscal__c,
                    tipoIdentificacaoFiscal__c,
                    IdentificacaoFiscalSemFormatacao__c 
                FROM
                    Account
                WHERE
                    (NOT identificacaoFiscal__c LIKE : '%0001%')
                    AND IdentificacaoFiscalSemFormatacao__c LIKE : raizCnpjMatrizes];
    }
}
