trigger EnderecoTrigger on Endereco__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        EnderecoBO.formatarCep(trigger.new, trigger.oldMap);
    }
    
}