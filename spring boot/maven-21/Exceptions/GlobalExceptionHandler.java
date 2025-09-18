package com.project.handly.Exceptions;

import com.project.handly.Utils.ResponseHandler;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

public class GlobalExceptionHandler {

    // Resource not found (User, Country, etc.)
    public static class NotFoundException extends RuntimeException {
        public NotFoundException(String message) {
            super(message);
        }
    }

    // Duplicate resource (Email, Phone, etc.)
    public static class DuplicateException extends RuntimeException {
        public DuplicateException(String message) {
            super(message);
        }
    }

    public static class BadRequestException extends RuntimeException {
        public BadRequestException(String message) {
            super(message);
        }
    }

    // Invalid login credentials
    public static class InvalidCredentialsException extends RuntimeException {
        public InvalidCredentialsException(String message) {
            super(message);
        }
    }

    // Unauthorized access (not logged in or no token)
    public static class UnauthorizedException extends RuntimeException {
        public UnauthorizedException(String message) {
            super(message);
        }
    }

    // Forbidden (logged in but no permission)
    public static class ForbiddenException extends RuntimeException {
        public ForbiddenException(String message) {
            super(message);
        }
    }

    // ---------------------- Global Exception Handler ----------------------
    @ControllerAdvice
    public static class Handler {

        @ExceptionHandler(NotFoundException.class)
        public ResponseEntity<Object> handleNotFound(NotFoundException ex) {
            return ResponseHandler.error(ex.getMessage(), HttpStatus.NOT_FOUND);
        }

        @ExceptionHandler(DuplicateException.class)
        public ResponseEntity<Object> handleDuplicate(DuplicateException ex) {
            return ResponseHandler.error(ex.getMessage(), HttpStatus.CONFLICT);
        }

        @ExceptionHandler(InvalidCredentialsException.class)
        public ResponseEntity<Object> handleInvalidCredentials(InvalidCredentialsException ex) {
            return ResponseHandler.error(ex.getMessage(), HttpStatus.UNAUTHORIZED);
        }

        @ExceptionHandler(UnauthorizedException.class)
        public ResponseEntity<Object> handleUnauthorized(UnauthorizedException ex) {
            return ResponseHandler.error(ex.getMessage(), HttpStatus.UNAUTHORIZED);
        }

        @ExceptionHandler(ForbiddenException.class)
        public ResponseEntity<Object> handleForbidden(ForbiddenException ex) {
            return ResponseHandler.error(ex.getMessage(), HttpStatus.FORBIDDEN);
        }

        @ExceptionHandler(BadRequestException.class)
        public ResponseEntity<Object> handleBadRequest(BadRequestException ex) {
            return ResponseHandler.error(ex.getMessage(), HttpStatus.BAD_REQUEST);
        }

        @ExceptionHandler(MethodArgumentNotValidException.class)
        public ResponseEntity<Object> handleValidationErrors(MethodArgumentNotValidException ex) {
            String errorMessage = ex.getBindingResult()
                    .getFieldErrors()
                    .stream()
                    .map(err -> err.getField() + ": " + err.getDefaultMessage())
                    .findFirst()
                    .orElse("Validation error");
            return ResponseHandler.error(errorMessage, HttpStatus.BAD_REQUEST);
        }

        @ExceptionHandler(Exception.class)
        public ResponseEntity<Object> handleGeneral(Exception ex) {
            return ResponseHandler.error("Unexpected error: " + ex.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
