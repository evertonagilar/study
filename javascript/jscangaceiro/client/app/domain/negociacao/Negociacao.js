class Negociacao {

    constructor(_data, _quantidade, _valor) {
        Object.assign(this, {_quantidade, _valor});
        this._data = new Date(_data.getTime());
        Object.freeze(this);
    }

    get data() {
        return this._data;
    }

    get quantidade() {
        return this._quantidade;
    }

    get valor() {
        return this._valor;
    }

    getVolume() {
        return this._quantidade * this._valor;
    }

}