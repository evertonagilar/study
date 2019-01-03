class Animal{

    constructor(nome){
        this._nome = nome;
    }
    
    get nome(){
        return this._nome;
    }

    set nome(value){
        return this._nome = value;
    }

}

class Dog extends Animal{
    constructor(nome){
        super(nome)
    }

    latir(){
        console.log("au au au!!!")
    }
}

module.exports.Dog = Dog
