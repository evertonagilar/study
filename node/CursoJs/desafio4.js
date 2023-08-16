const fs = require("fs")
const path = require("path")

function fileAsString(filename){
    return new Promise(resolv => {
        fs.readFile(filename, (err, content) => resolv(content))
    })
}

// teste

const filename = path.join(__dirname, "arquivo.txt")
fileAsString(filename)
    .then(content => `conteúdo do arquivo ${filename}: ${content}`)
    .then(console.log)
