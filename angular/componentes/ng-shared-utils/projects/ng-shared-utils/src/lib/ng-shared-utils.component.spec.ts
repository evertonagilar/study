import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { NgSharedUtilsComponent } from './ng-shared-utils.component';

describe('NgSharedUtilsComponent', () => {
  let component: NgSharedUtilsComponent;
  let fixture: ComponentFixture<NgSharedUtilsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ NgSharedUtilsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(NgSharedUtilsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
