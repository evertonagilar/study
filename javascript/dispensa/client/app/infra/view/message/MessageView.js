class MessageView{
    constructor(seletor) {
        this._element = document.querySelector(seletor);
        if (!this._element){
            this._element = document.createElement("div");
            document.body.prepend(this._element);
        }
    }

    template(message){
        return message.text ? `<p class='alert alert-${message.type}' >${message.text}</p>` : ''
    }

    update(message){
        this._element.innerHTML = this.template(message)
    }

}