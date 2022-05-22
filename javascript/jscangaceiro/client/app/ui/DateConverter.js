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
        return `${date.getDate()}/${date.getMonth()}/${date.getFullYear()}`
    }

    static toTextYYYY_MM_DD(date) {
        const ano = date.getFullYear();
        const mes = new String(date.getMonth()).padStart(2, '0');
        const dia = new String(date.getDate()).padStart(2, '0');
        return `${ano}-${mes}-${dia}`
    }

}