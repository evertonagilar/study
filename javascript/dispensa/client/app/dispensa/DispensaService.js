class DispensaService {

    getDadosImportacao() {
        return new Promise((resolve, reject) => {
            const xhr = new XMLHttpRequest();
            xhr.onreadystatechange = () => {
                console.log(`negociacoes/semana onreadystatechange: ${xhr.readyState}`);
                if (xhr.readyState == 4) {
                    if (xhr.status == 200) {
                        let result = xhr.responseText;
                        console.log("Dados servidor: ");
                        console.log(result);
                        result = JSON.parse(result)
                            .map(obj => new Dispensa(new Date(obj.data), obj.quantidade, obj.valor));
                        resolve(result);
                    } else {
                        reject("Ocorreu um erro ao realizar a importação.");
                    }
                }
            }
            xhr.open('GET', 'negociacoes/semana');
            xhr.send();
        });
    }


}