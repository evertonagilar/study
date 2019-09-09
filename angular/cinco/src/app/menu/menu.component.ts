import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.css']
})
export class MenuComponent implements OnInit {

  private user = "Joao";

  constructor() { }

  ngOnInit() {
    console.log("ngOnInit of MenuComponent");
  }

}
