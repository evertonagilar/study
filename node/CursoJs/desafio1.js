// calcular(3)(7)(fn)

const soma = (a, b) => a + b
const mult = (a, b) => a * b

function calcular(a, b, fn){
    return function operacaoMatematica(fn){
        return fn(a, b)
    }
}

function somando(a){
    return function(b){
        return a + b
    }
}


const fazer = calcular(2, 3)
let ret = fazer(soma)
console.log(`Resultado: ${ret}`)

ret = fazer(mult)
console.log(`Resultado: ${ret}`)

ret = somando(2)
ret = ret(2)
console.log(`Resultado: ${ret}`)

let soma_array = (...numeros) => {
    console.log(`is array: ${Array.isArray(numeros)}`)
    let total = 0;
    for (n of numeros){
        total += n;
    }
    return total;
}

ret = soma_array(1, 2, 3, 4, 5, 6)
console.log(`Resultado: ${ret}`)



Array.prototype.primeiro = function pegaPrimeiro(){
    console.log(`Quem eh this: ${this}`);
    console.log(`Primeiro parâmetro: ${this[0]}`);
}


let nums = [100, 20, 40, 30]
nums.primeiro()


