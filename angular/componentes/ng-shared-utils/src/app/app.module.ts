import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { NgSharedUtilsModule } from 'ng-shared-utils';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    NgSharedUtilsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
