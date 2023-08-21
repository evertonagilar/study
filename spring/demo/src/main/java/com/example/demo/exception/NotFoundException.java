package com.example.demo.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class NotFoundException extends DemoException {
    private static final long serialVersionUID = 7860691238040502302L;

    @Override
    public String getMessage() {
        return super.getMessage();
    }

    public NotFoundException() {
        super("Não foi possível encontrar o registro");
    }
}
