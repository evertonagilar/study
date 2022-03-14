class Message{
    constructor(text, type) {
        this._text = text;
        this._type = type ? type : 'info';
        Object.freeze(this);
    }

    get text(){
        return this._text;
    }

    get type(){
        return this._type;
    }

}