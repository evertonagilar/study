class DispensaController extends BaseController {

    constructor() {
        super();
        const $ = document.querySelector.bind(document);
        this._inputData = $("#data");
        this._inputQuantidade = $("#quantidade");
        this._inputValor = $("#valor");
        this._dispensas = new ListaDispensa();
        this._listaDispensaView = new ListaDispensaView("#lista_dispensa");
        this._limpaFormulario();
    }

    _limpaFormulario() {
        this._inputData.value = DateConverter.toTextYYYY_MM_DD(new Date());
        this._inputQuantidade.value = 1;
        this._inputValor.value = 1;
        this._inputData.focus();
    }


    adiciona(event) {
        event.preventDefault();

        const dispensa = new Dispensa(
            DateConverter.toDate(this._inputData.value),
            parseInt(this._inputQuantidade.value),
            parseFloat(this._inputValor.value));
        this._dispensas.add(dispensa);

        this._listaDispensaView.update(this._dispensas);
        this._limpaFormulario();
        this.showMessage("Dispensa cadastrado com sucesso.");
    }

}