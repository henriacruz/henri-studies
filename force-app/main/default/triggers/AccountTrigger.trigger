trigger AccountTrigger on Account (before insert, before update, after insert, after update) {

    if(trigger.isBefore){
        AccountBO.validaNumeroIdentificacao(trigger.new);
        AccountBO.atribuiMatriz(trigger.new);
    }
    else if(trigger.isAfter){
        AccountBO.atribuiFiliais(trigger.new);
    }
    
}