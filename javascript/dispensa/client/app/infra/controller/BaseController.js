class BaseController{

    constructor() {
        this._messageView = new MessageView("#message");
    }

    infoMessage(text){
        this._messageView.update(new Message(text, "info"));
    }

    errorMessage(text){
        this._messageView.update(new Message(text, "danger"));
    }

}