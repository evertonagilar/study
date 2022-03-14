class BaseController{

    constructor() {
        this._messageView = new MessageView("#message");
    }

    showMessage(text, type){
        this._messageView.update(new Message(text, type));
    }
}