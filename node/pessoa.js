module.exports = {

    Pessoa : function (nome){
        this.nome = nome;
        this.falar = function(){
            console.log(`My name is ${this.nome}`)
        }
    },

    Pai : function(nome){
        this.nome = nome
        this.__proto__ = this.Pessoa
    }

}

