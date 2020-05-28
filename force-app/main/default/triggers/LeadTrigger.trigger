trigger LeadTrigger on Lead (before insert, before update) {
    if(trigger.isBefore){
        LeadBO.verificarNumeroIdentificacao(trigger.new);
    }
}