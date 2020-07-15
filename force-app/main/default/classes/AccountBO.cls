public with sharing class AccountBO {

    public static void validaNumeroIdentificacao(List<Account> accounts, Map<Id,Account> oldMapAccounts) {
        oldMapAccounts = oldMapAccounts == null ? new Map<Id,Account>() : oldMapAccounts;

        for (Account acc : accounts) {   
            if(!String.isBlank(acc.identificacaoFiscal__c) && acc.tipoIdentificacaoFiscal__c == 'CPF'){
                if(acc.identificacaoFiscal__c.length() <> 14){
                    acc.addError('O campo número da indentificação para CPF deve conter 14 dígitos'); 
                }
            }
            else if(!String.isBlank(acc.identificacaoFiscal__c) && acc.tipoIdentificacaoFiscal__c == 'CNPJ'){
                if(acc.identificacaoFiscal__c.length() <> 18){
                    acc.addError('O campo número da indentificação para CNPJ deve conter 18 dígitos');
                }
            }
        } 
    }

    public static void atribuiMatriz(List<Account> accounts, Map<Id,Account> oldMapAccounts){
        oldMapAccounts = oldMapAccounts == null ? new Map<Id,Account>() : oldMapAccounts;
        List<Account> filiais = new List<Account>();

        for (Account account : accounts) {
            Account oldAccount = oldMapAccounts.get(account.Id);
            if (!String.isBlank(account.identificacaoFiscal__c) && !account.identificacaoFiscal__c.contains('0001')) {
                if (oldAccount != null){
                    if (account.identificacaoFiscal__c != oldAccount.identificacaoFiscal__c) {
                        filiais.add(account);
                    }
                    continue;
                }else{
                    filiais.add(account);
                }
            }
        }
        
        if (!filiais.isEmpty()) {
            Set<String> raizCNPJs = new Set<String>();
            for (Account filial : filiais) {
                if (!String.isBlank(filial.IdentificacaoFiscalSemFormatacao__c)) {
                    String raizCNPJ = filial.IdentificacaoFiscalSemFormatacao__c.substring(0,8) + '%';
                    raizCNPJs.add(raizCNPJ);
                }
            }
            if (!raizCNPJs.isEmpty()) {
                Map<Id,Account> mapAccounts = new Map<Id,Account>(AccountDAO.getParentAccounts(raizCNPJs));
                for (Account filial : filiais) {
                    String raizCNPJFilial = !String.isBlank(filial.IdentificacaoFiscalSemFormatacao__c) ? filial.IdentificacaoFiscalSemFormatacao__c.substring(0,8) : 'blank';
                    for (Account account : mapAccounts.values()) {
                        String raizCNPJMatriz = !String.isBlank(account.IdentificacaoFiscalSemFormatacao__c) ? account.IdentificacaoFiscalSemFormatacao__c.substring(0,8) : 'none';
                        if(raizCNPJFilial == raizCNPJMatriz){
                            filial.ParentId = account.Id;
                        }
                    }
                }
            }
        }
    }

    public static void atribuiFiliais(List<Account> accounts, Map<Id,Account> oldMapAccounts){
        Set<String> cnpjMatrizes = new Set<String>();
        Set<String> raizCNPJMatrizes = new Set<String>();
        List<Account> matrizes = new List<Account>();
        oldMapAccounts = oldMapAccounts == null ? new Map<Id,Account>() : oldMapAccounts;

        for (Account account : accounts) {
            Account oldAccount = oldMapAccounts.get(account.Id);
            if (!String.isBlank(account.identificacaoFiscal__c) && account.identificacaoFiscal__c.contains('0001')) {
                if (oldAccount != null){
                    if (account.identificacaoFiscal__c != oldAccount.identificacaoFiscal__c) {
                        cnpjMatrizes.add(account.IdentificacaoFiscalSemFormatacao__c);
                        matrizes.add(account);
                    }
                    continue;
                }else{
                    cnpjMatrizes.add(account.IdentificacaoFiscalSemFormatacao__c);
                    matrizes.add(account); 
                } 
            }
        }

        if (!cnpjMatrizes.isEmpty()) {
            for (String raiz : cnpjMatrizes) {
                String raizFormatada = raiz.substring(0,8)+'%';
                raizCNPJMatrizes.add(raizFormatada);
            }

            Map<Id,Account> mapFiliais = new Map<Id,Account>(AccountDAO.getSubsidiaryAccounts(raizCnpjMatrizes));
            List<Account> filiaisUpdate = new List<Account>();

            if(!matrizes.isEmpty() && !mapFiliais.isEmpty()){
                for (Account filial : mapFiliais.values()) {
                    String raizCNPJFilial = !String.isBlank(filial.IdentificacaoFiscalSemFormatacao__c) ? filial.IdentificacaoFiscalSemFormatacao__c.substring(0,8) : 'blank';
                    for (Account matriz : matrizes) {
                        String raizCNPJMatriz = !String.isBlank(matriz.IdentificacaoFiscalSemFormatacao__c) ? matriz.IdentificacaoFiscalSemFormatacao__c.substring(0,8) : 'none';
                        if(raizCNPJFilial == raizCNPJMatriz){
                            filial.ParentId = matriz.Id;
                            filiaisUpdate.add(filial);
                        }
                    }
                }
                if (!filiaisUpdate.isEmpty())
                    update filiaisUpdate;
            }
        }
    }
}