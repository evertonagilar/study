class Dispensa {

    constructor(_data, _quantidade, _valor) {
        Object.assign(this, {_quantidade, _valor});
        this._data = new Date(_data.getTime());
        if (!this._data){
            throw new CampoObrigatorioException('Data');
        }
        if (!this._quantidade || this._quantidade < 0 || this._quantidade > 999){
            throw new RegraNegocioException("Quantidade inválida.");
        }
        if (!this._valor || this._valor < 0 || this._valor > 9999){
            throw new RegraNegocioException("Valor inválido.");
        }
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

    get total() {
        return this._quantidade * this._valor;
    }

}