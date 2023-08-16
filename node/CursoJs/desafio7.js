const fs = require("fs")
const path = require("path")

function leArquivo(nome){
    return new Promise(function(resolve, reject){
        fs.readFile(nome, (err, content) => {
            console.log(`arquivo ${nome} lido`)
            resolve(content.toString())
        })
    })
}


const nomeArquivo = path.join(__dirname, "arquivo.txt")
leArquivo(nomeArquivo).then(console.log)



