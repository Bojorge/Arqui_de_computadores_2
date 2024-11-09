#ifndef CORE_H
#define CORE_H

//#include <cstdint>
#include <array>
#include <string>
#include "cache.h"
#include "ram.h"
#include "bus.h"
#include "instructions_memory.h"

struct core {
    cache core_cache;                         // Cada core tiene su propia memoria cache
    std::array<uint64_t, 4> registers;        // 4 registros de 64 bits: REG0, REG1, REG2, REG3

    // Función para cargar datos desde cache o RAM en caso de un miss
    uint64_t load(int block, uint64_t addr, bus bus);

    // Función para almacenar datos en cache
    void store(int block, uint64_t addr, uint64_t data, bus bus);

    // Incrementar el valor en un registro 
    void inc(int reg);

    // Decrementar el valor en un registro 
    void dec(int reg);

    // Salto condicional si el valor en el registro no es cero
    void jnz(int reg, std::string label, instruction_memory &inst_mem);
};

#endif  // CORE_H
