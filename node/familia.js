const { arbusto } = require('./arvore')

const { Pessoa, Pai } = require('./pessoa');
const { Dog } = require('./animal')


function Casa(...membros){
    this.membros = membros;

    this.show = function(){
        console.log('Membros da família:');
        this.membros.forEach(e => console.log(e.nome, e instanceof Pai ? '[PAI]' : ''));
    }
    
}


let xiru = new Pai("Xiru");
let joao = new Pessoa("Joao");
let maria = new Pessoa("Maria");
const laranjeira = new arbusto("laranjeira")

const bob = new Dog("Bob");
bob.latir()

joao.falar();
maria.falar();

const casa = new Casa(joao, maria, xiru, bob);
casa.show()

const saudacao = require('saudacao')

console.log(saudacao.ola)

const lodash = require('lodash')
console.log(lodash.random(1, 100))

