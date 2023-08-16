function getNumeroAleatorio(fator = 10){
    return new Promise(resolv => {
        setTimeout(() => {
            console.log(`fator: ${fator}`)
            const num = Math.random() * fator 
            resolv(num)
        }, 100)
    })
}


const imprimeEGeraOutro = num => {
    console.log(`num: ${num}`)
    return getNumeroAleatorio(num)
}

getNumeroAleatorio()
    .then(imprimeEGeraOutro)
    .then(imprimeEGeraOutro)
    .then(imprimeEGeraOutro)
    .then(console.log)
