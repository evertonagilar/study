import { TestBed } from '@angular/core/testing';

import { NgSharedUtilsService } from './ng-shared-utils.service';

describe('NgSharedUtilsService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: NgSharedUtilsService = TestBed.get(NgSharedUtilsService);
    expect(service).toBeTruthy();
  });
});
