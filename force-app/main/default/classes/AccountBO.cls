public with sharing class AccountBO {

    public static void validaNumeroIdentificacao(List<Account> accounts) {
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

    public static void atribuiMatriz(List<Account> accounts){
        List<Account> filiais = new List<Account>();
        for (Account account : accounts) {
            if(!String.isBlank(account.identificacaoFiscal__c) && !account.identificacaoFiscal__c.contains('0001')){
                filiais.add(account);
            }
        }
        
        Map<Id,Account> mapAccounts = new Map<Id,Account>(AccountDAO.getParentAccounts());

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

    public static void atribuiFiliais(List<Account> accounts){
        Set<String> cnpjMatrizes = new Set<String>();
        Set<String> raizCNPJMatrizes = new Set<String>();
        List<Account> matrizes = new List<Account>();

        for (Account account : accounts) {
            if(!String.isBlank(account.identificacaoFiscal__c) && account.identificacaoFiscal__c.contains('0001')){
                cnpjMatrizes.add(account.IdentificacaoFiscalSemFormatacao__c);
                matrizes.add(account);
            }
        }
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
            if (!filiaisUpdate.isEmpty()) {
                update filiaisUpdate;
            }
        }
        
    }
}