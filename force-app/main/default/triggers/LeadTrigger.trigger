trigger LeadTrigger on Lead (before insert, before update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            LeadBO.verificarNumeroIdentificacao(trigger.new, null);
        }
        if (trigger.isUpdate){
            LeadBO.verificarNumeroIdentificacao(trigger.new, trigger.oldMap);
        }
        
    }
}