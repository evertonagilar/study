class CampoObrigatorioException extends RegraNegocioException{

    constructor(campo) {
        super(`É necessário informar o campo: ${campo}`);
    }

}