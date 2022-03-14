class DispensaController extends BaseController {

    constructor() {
        super();
        const $ = document.querySelector.bind(document);
        this._inputData = $("#data");
        this._inputQuantidade = $("#quantidade");
        this._inputValor = $("#valor");
        this._listaDispensas = new DataBind(new ListaDispensa(), new ListaDispensaView("#lista_dispensa"));
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
        this._listaDispensas.add(dispensa);
        this._limpaFormulario();
        this.showMessage("Dispensa cadastrado com sucesso.");
    }

    apaga(event){
        this._listaDispensas.limpa();
        this.showMessage("Dispensa apagadas com sucesso.");
    }


}