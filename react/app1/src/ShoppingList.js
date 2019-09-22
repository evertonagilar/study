import React from 'react';
import ReactDOM from 'react-dom'


class ShoppingList extends React.Component {
    constructor(){
        super();
        console.log('Component criado')
    }

    render() {
        return (
            <div className="shopping-list">
                <h1>Shopping List for {this.props.name}</h1>
                <ul>
                    <li>Instagram</li>
                    <li>WhatsApp</li>
                    <li>Oculus</li>
                </ul>
            </div>
        );
    }
}

export default ShoppingList;