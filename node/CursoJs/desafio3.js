const carrinho = [
    { nome: "Erva", preco: 3, qtd: 6, tipo: 'comida', cestaBasica: true },
    { nome: "Coca", preco: 8, qtd: 5, tipo: 'bebida', cestaBasica: false },
    { nome: "Caneta", preco: 1, qtd: 35, tipo: 'bazar', cestaBasica: false },
    { nome: "Tesoura", preco: 15, qtd: 3, tipo: 'bazar', cestaBasica: false },
    { nome: "Caderno", preco: 26, qtd: 2, tipo: 'bazar', cestaBasica: false },
    { nome: "Arroz", preco: 12, qtd: 9, tipo: 'comida', cestaBasica: true }
]

//console.log("Produtos: ", carrinho)

let cestaBasica = carrinho.filter(p => p.cestaBasica)
console.log("Cesta básica: ", cestaBasica)

Array.prototype.myFilter = function(fn){
    let novoArray = []
    for (let i = 0; i < this.length; i++){
        let inclui = fn(this[i], i, this)
        if (inclui){
            novoArray.push(this[i])
        }            
    }
    return novoArray
}


Array.prototype.myMap = function(fn){
    let novoArray = []
    for (let i = 0; i < this.length; i++){
        let novo = fn(this[i], i, this)
        novoArray.push(novo)
    }
    return novoArray
}

Array.prototype.myReduce = function(fn, inicial){
    let acc = inicial
    for (let i = 0; i < this.length; i++){
        if (acc == undefined && i === 0){
            acc = this[0]
        }
        acc = fn(acc, this[i], i, this)
    }
    return acc
}


let cestaBasica2 = carrinho.myFilter((p) => p.cestaBasica)
console.log("Cesta básica: ", cestaBasica2)

let cestaComTotais = carrinho.myMap(p => {
    p.total = p.preco * p.qtd
    return p
})
console.log("Cesta: ", cestaComTotais)


let total = cestaComTotais.myReduce((acc, item) => acc + item.total, 0)
console.log("Total da compra: ", total)
