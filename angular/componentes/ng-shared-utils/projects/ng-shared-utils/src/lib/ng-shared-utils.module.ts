import { NgModule } from '@angular/core';
import { NgSharedUtilsComponent } from './ng-shared-utils.component';
import { OutroComponent } from './outro/outro.component';



@NgModule({
  declarations: [NgSharedUtilsComponent, OutroComponent],
  imports: [
  ],
  exports: [NgSharedUtilsComponent, OutroComponent]
})
export class NgSharedUtilsModule { }
