class InvalidDateException extends RegraNegocioException{

    constructor(dateStr) {
        super(`Data inválida: ${dateStr}`);
    }

}