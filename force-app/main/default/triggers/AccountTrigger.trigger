trigger AccountTrigger on Account (before insert, before update, after insert, after update) {

    if(trigger.isBefore){
        if(trigger.isInsert){
            AccountBO.validaNumeroIdentificacao(trigger.new, null);
            AccountBO.atribuiMatriz(trigger.new, null);
        }
        if (trigger.isUpdate) {
            AccountBO.validaNumeroIdentificacao(trigger.new, trigger.oldMap);
            AccountBO.atribuiMatriz(trigger.new, trigger.oldMap);
        }
        
    }
    else if(trigger.isAfter){
        if (trigger.isInsert) {
            AccountBO.atribuiFiliais(trigger.new, null);
        }
        if (trigger.isUpdate) {
            AccountBO.atribuiFiliais(trigger.new, trigger.oldMap);
        }
        
    }
    
}