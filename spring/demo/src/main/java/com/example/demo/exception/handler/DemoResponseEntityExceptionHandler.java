package com.example.demo.exception.handler;

import com.example.demo.exception.DemoException;
import com.example.demo.exception.ExceptionResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import java.util.Date;

@RestController
@ControllerAdvice
public class DemoResponseEntityExceptionHandler extends ResponseEntityExceptionHandler {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ExceptionResponse> handleAllExceptions(Exception ex, WebRequest request) {
        var response = new ExceptionResponse(
                new Date(),
                ex.getMessage(),
                request.getDescription(false));
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(DemoException.class)
    public ResponseEntity<ExceptionResponse> handleAllExceptions(DemoException ex, WebRequest request) {
        var response = new ExceptionResponse(
                new Date(),
                ex.getMessage(),
                request.getDescription(false));
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }


}
