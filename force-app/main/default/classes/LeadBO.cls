public with sharing class LeadBO {
    public static void verificarNumeroIdentificacao(List<Lead> leads, Map<Id,Lead> oldMapLeads){
        Set<String> setIdentificacao = new Set<String>();
        oldMapLeads = oldMapLeads == null ? new Map<Id,Lead>() : oldMapLeads;
        System.debug('old map leads: '+oldMapLeads);

        for (Lead lead : leads) {
            Lead oldLead = oldMapLeads.get(lead.Id);
            if (oldLead == null) {
                setIdentificacao.add(lead.IdentificacaoFiscal__c);
                continue;
            }
            if(lead.IdentificacaoFiscal__c != oldLead.IdentificacaoFiscal__c)
                setIdentificacao.add(lead.IdentificacaoFiscal__c);
        }

        if (!setIdentificacao.isEmpty()){
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
}
