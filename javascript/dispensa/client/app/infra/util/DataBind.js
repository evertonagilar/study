class DataBind {

    constructor(model, view) {
        const proxy = new Proxy(model, {
            get(target, property, receiver) {
                if (typeof target[property] === 'function') {
                    return new Proxy(target[property], {
                        apply: (target, thisArg, argumentsList) => {
                            const result = Reflect.apply(target, thisArg, argumentsList);
                            view.update(model);
                            return result;
                        }
                    });
                } else {
                    const result = Reflect.get(target, property, receiver);
                    if (!property.startsWith("_")) {
                        view.update(model);
                    }
                    return result;
                }
            },
            set(target, property, value, receiver) {
                const result = Reflect.set(target, property, value);
                view.update(model);
                return result;
            }
        });
        return proxy;
    }

}