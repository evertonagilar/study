class DateConverter {

    constructor() {
        throw new Error("DataConverter não pode ser instanciada!");
    }


    static toDate(text) {
        if (/^\d{4}\/\d{2}\/\d{2}$/.test(text)) {
            return new Date(text.split("/"));
        } else if (/^\d{4}-\d{2}-\d{2}$/.test(text)) {
            return new Date(text.split("-"));
        } else if (/^\d{2}\/\d{2}\/\d{4}$/.test(text)) {
            const data = text.split("/");
            return new Date([data[2], data[1], data[0]]);
        } else {
            throw new Error(`Data inválida: ${text}`);
        }
    }

    static toText(date) {
        const dia = date.getDate().toString().padStart(2, '0');
        const mes = date.getMonth().toString().padStart(2, '0');
        const ano = date.getFullYear();
        return `${dia}/${mes}/${ano}`
    }

    static toTextYYYY_MM_DD(date) {
        const dia = date.getDate().toString().padStart(2, '0');
        const mes = date.getMonth().toString().padStart(2, '0');
        const ano = date.getFullYear();
        return `${ano}-${mes}-${dia}`
    }

}