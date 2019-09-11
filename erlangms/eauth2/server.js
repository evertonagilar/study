const http = require('http')
const fs = require('fs')
const port = 3000;
const ip = 'localhost'

const server = http.createServer((req, res) => {
    console.log(`Request received ${req.url}`)
    res.setHeader("Access-Control-Allow-Origin", "*")
    res.setHeader("Access-Control-Allow-Headers", "authorizaton")
    res.setHeader('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
    res.setHeader('Access-Control-Expose-Headers', 'Cache-Control, Content-Language, Content-Type, Expires, Last-Modified, Pragma, Content-Length')
    if (req.url == '/eauth2.js') {
        res.end(fs.readFileSync('eauth2.js'))
    } else {
        res.end(fs.readFileSync('index.html'))
    }

    res.end('<h1>URL sem resposta</h1>')

})

server.listen(port, ip, () => {
    console.log(`Servidor rodando em http://'${ip}:${port}`)
    console.log('Para derrubar o servidor: ctrl + c');
})