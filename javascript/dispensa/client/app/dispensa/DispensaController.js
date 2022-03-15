class DispensaController extends BaseController {

    constructor() {
        super();
        const $ = document.querySelector.bind(document);
        this._inputData = $("#data");
        this._inputQuantidade = $("#quantidade");
        this._inputValor = $("#valor");
        this._listaDispensas = new DataBind(new ListaDispensa(), new ListaDispensaView("#lista_dispensa"));
        this._dispensaService = new DispensaService();
        this._limpaFormulario();
    }

    _limpaFormulario() {
        const amanha = new Date().addDays(1);
        this._inputData.value = DateConverter.toText(amanha);
        this._inputQuantidade.value = 1;
        this._inputValor.value = 1;
        this._inputData.focus();
    }


    adiciona(event) {
        event.preventDefault();
        try {
            const dispensa = new Dispensa(
                DateConverter.toDate(this._inputData.value),
                parseInt(this._inputQuantidade.value),
                parseFloat(this._inputValor.value));
            this._listaDispensas.add(dispensa);
            this._limpaFormulario();
            this.infoMessage("Dispensa cadastrada com sucesso.");
        } catch (exception) {
            this.errorMessage(exception.message);
        }
    }

    apaga(event) {
        this._listaDispensas.limpa();
        this.infoMessage("Dispensa apagadas com sucesso.");
    }

    importa(event) {
        this._dispensaService.getDadosImportacao()
            .then(lista => {
                    lista.forEach(dispensa => this._listaDispensas.add(dispensa));
                    this.infoMessage("Importação realizada com sucesso.");
                },
                error => {
                    this.errorMessage(error);
                }
            )
    }


}