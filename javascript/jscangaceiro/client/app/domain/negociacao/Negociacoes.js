class Negociacoes{

    constructor() {
        this._lista = [];
    }

    add(negociacao){
        this._lista.push(negociacao);
    }

    get list(){
        return this._lista;
    }


}