trigger EnderecoTrigger on Endereco__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            EnderecoBO.formatarCep(trigger.new);
        }
    }
    
}