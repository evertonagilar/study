class RegraNegocioException extends Error{

    constructor(message = "Uma excessão de regra de negócio aconteceu.") {
        super(message);
        this.name = this.constructor.name;
    }

}