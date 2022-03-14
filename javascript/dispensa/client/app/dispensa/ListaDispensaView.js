class ListaDispensaView {

    constructor(seletor) {
        this._element = document.querySelector(seletor);
    }

    template(lista) {
        return `<table class="table table-hover table-bordered">
                    <thead>
                        <tr>
                            <th>DATA</th>
                            <th>QUANTIDADE</th>
                            <th>VALOR</th>
                            <th>TOTAL</th>
                        </tr>
                    </thead>
                    
                    <tbody>
                        ${lista.toArray().map(dispensa =>
                            `<tr>
                                 <td>${DateConverter.toText(dispensa.data)}</td>
                                 <td>${dispensa.quantidade}</td>
                                 <td>${dispensa.valor}</td>
                                 <td>${dispensa.total}</td>
                             </tr>
                            `).join('')}
                    </tbody>

                    <tfoot>
                        <tr>
                            <td colspan="3">Total</td>
                            <td>${lista.total}</td>
                        </tr>
                    </tfoot>
                </table>`
    }


    update(lista) {
        console.log("Atualizando view...")
        this._element.innerHTML = this.template(lista);
    }

}