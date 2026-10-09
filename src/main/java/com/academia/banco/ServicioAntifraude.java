package com.academia.banco;

import java.math.BigDecimal;

public interface ServicioAntifraude {
    boolean esSospechosa(String numeroCuenta, BigDecimal monto);
}
