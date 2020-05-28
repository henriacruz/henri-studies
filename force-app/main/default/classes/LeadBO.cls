public with sharing class LeadBO {
    public static void verificarNumeroIdentificacao(List<Lead> leads){
        Set<String> setIdentificacao = new Set<String>();
        for (Lead lead : leads) {
            setIdentificacao.add(lead.IdentificacaoFiscal__c);
        }

        List<Account> accounts = AccountDAO.getAccountsWithIdentifier(setIdentificacao);
        Map<String,Account> mapAccounts = new Map<String,Account>();
        if(!accounts.isEmpty()){
            for (Account account : accounts)
                mapAccounts.put(account.IdentificacaoFiscal__c, account);

            for (Lead lead : leads) {
                Account acc = mapAccounts.get(lead.IdentificacaoFiscal__c);
                    if(lead.IdentificacaoFiscal__c == acc.IdentificacaoFiscal__c && !String.isBlank(lead.IdentificacaoFiscal__c)){
                        lead.addError('Já existe a conta: '+acc.Name+' com este número de Identificação cadastrado');
                    }
            }
        }
    }
}
