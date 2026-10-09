package com.academia.banco;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;

public interface RepositorioCuentas {
    Optional<CuentaBancaria> buscar(String numeroCuenta);
    BigDecimal totalRetiradoEn(String numeroCuenta, LocalDate fecha);
    void guardar(String numeroCuenta, CuentaBancaria cuenta);
}
