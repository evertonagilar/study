class ListaDispensa {

    constructor() {
        this._lista = [];
        Object.freeze(this);
    }

    add(negociacao){
        this._lista.push(negociacao);
    }

    toArray(){
        return [].concat(this._lista);
    }

    get total(){
        return this._lista.reduce((total, dispensa) => total + dispensa.total, 0);
    }


}