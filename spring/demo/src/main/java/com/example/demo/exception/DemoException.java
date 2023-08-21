package com.example.demo.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.BAD_REQUEST)
public class DemoException extends RuntimeException {
    private static final long serialVersionUID = 3461465005694735857L;

    public DemoException(String message) {
        super(message);
    }
}
