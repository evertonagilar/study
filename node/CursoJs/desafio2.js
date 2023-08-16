const fs = require("fs")
const path = require("path")

const caminho = path.join(__dirname, "arquivo.txt")
console.log(caminho)

function exibirConteudo(_, conteudo){
    console.log(conteudo.toString());
}

console.log("inicio")
fs.readFile(caminho, exibirConteudo)
console.log("fim")






