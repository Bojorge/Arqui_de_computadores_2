#ifndef BUS_H
#define BUS_H

#include <array>
#include <cstdint>
#include <string>
#include <iostream>
#include "cache.h"

// Bus del sistema
struct bus {
    std::array<uint64_t, 256> address_port;  // Puerto de direcciones (conectado a RAM y cache de cada core)
    std::array<uint64_t, 256> data_port;     // Puerto de datos (conectado a RAM y cache de cada core)
    std::array<cache, 4> connected_caches;   // Puerto compartido para estados MOESI entre caches de los cores

    // Contadores para eventos del bus
    int read_requests = 0;
    int write_requests = 0;
    int invalidations = 0;
    uint64_t data_transmitted = 0;

    // Constructor
    bus();

    // Función para manejar una solicitud de lectura en el bus
    uint64_t read_request(uint64_t address, uint64_t cache_index, uint64_t cache_block);

    // Función para manejar una solicitud de escritura en el bus
    void write_request(uint64_t address, uint64_t data, uint64_t cache_index, uint64_t cache_block);

    // Función para actualizar el estado MOESI en el bus
    void update_moesi_state(uint64_t address, uint64_t data, uint64_t cache_index, uint64_t cache_block);

    // Función para imprimir el estado del bus
    void print_bus_state() const;
};

#endif // BUS_H
