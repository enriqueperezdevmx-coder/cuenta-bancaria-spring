package com.academia.banco;

public interface Notificador {
    void enviarSms(String numeroCuenta, String mensaje);
}
