import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { OutroComponent } from './outro.component';

describe('OutroComponent', () => {
  let component: OutroComponent;
  let fixture: ComponentFixture<OutroComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ OutroComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(OutroComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
