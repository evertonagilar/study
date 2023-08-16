const fs = require('fs').promises
const path = require('path')

async function leArquivo(filename){
    return fs.readFile(filename)
}


function leArquivo2(filename){
    return new Promise(resolv => {
        fs.readFile(filename, (err, content) => resolv(content.toString()))
    })

}

const arq = path.join(__dirname, "arquivo.txt")
leArquivo(arq).then(texto => {
    console.log("recebi o texto")
    console.log(texto.toString())
})

