class NegociacaoController {

    constructor() {
        const $ = document.querySelector.bind(document);
        this._inputData = $("#data");
        this._inputQuantidade = $("#quantidade");
        this._inputValor = $("#valor");
        this._limpaFormulario();
    }

    _limpaFormulario() {
        this._inputData.value = DateConverter.toTextYYYY_MM_DD(new Date());
        this._inputQuantidade.value = 1;
        this._inputValor.value = 0;
        this._inputData.focus();
        this._negociacoes = new Negociacoes();
    }


    adiciona(event) {
        event.preventDefault();

        const negociacao = new Negociacao(DateConverter.toDate(this._inputData.value),
            parseInt(this._inputQuantidade.value),
            parseFloat(this._inputValor.value));
        this._negociacoes.add(negociacao);

        console.log(this._negociacoes.list);
        this._limpaFormulario();

    }

}