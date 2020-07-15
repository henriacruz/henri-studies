import { LightningElement, api, track, wire } from 'lwc';
import { getRecord} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CEP_FIELD from '@salesforce/schema/Endereco__c.CEP__c';
import ENDERECO_FIELD from '@salesforce/schema/Endereco__c.EnderecoCompleto__c';
import preencherEndereco from '@salesforce/apex/EnderecoBO.preencherEndereco';
import preencherGeolocalizao from '@salesforce/apex/EnderecoBO.preencherGeolocalizao';


export default class BuscaCep extends LightningElement {
    @api recordId;
    @track error;
    endereco;
    cep;
    enderecoCompleto;

    @wire(getRecord, { recordId: '$recordId', fields: [CEP_FIELD, ENDERECO_FIELD] })
    wiredRecord({error, data}){
        if(error){
            let message = 'Unknown error';
        }
        else if(data){
            this.endereco = data;
            this.cep = this.endereco.fields.CEP__c.value;
            this.enderecoCompleto = this.endereco.fields.EnderecoCompleto__c.value;;
        }
    }

    buscaCepClick(event) {
        this.showNotification(this,'Sucesso','Serviço de Busca CEP iniciado com sucesso','success');
        preencherEndereco({ enderecoId: this.recordId});
        setTimeout(function (){
            window.location.reload(1);
        }, 3000);
    }

    buscaGeoClick(event) {
        this.showNotification(this,'Sucesso','Serviço de Busca Geo com sucesso','success');
        preencherGeolocalizao({ enderecoId: this.recordId});
        setTimeout(function (){
            window.location.reload(1);
        }, 3000);
    }

    showNotification(component, title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        component.dispatchEvent(evt);
    }
}