#include "core.h"
#include "ram.h"
#include "bus.h"

int main() {
    RAM memory;
    bus system_bus;
    core coreA, coreB;

    uint64_t address = 10;  // Dirección de prueba en RAM

    // Primera lectura en Core A (debe ir a estado Exclusive E)
    coreA.load(0, address, memory, system_bus);

    // Imprimir estados para verificar el cumplimiento del protocolo
    coreA.core_cache.print_cache_state("Core A");
    coreB.core_cache.print_cache_state("Core B");

    // Core B intenta leer el mismo dato (debe cambiar a estado Shared S en ambos cores)
    coreB.load(0, address, memory, system_bus);

    // Imprimir estados para verificar el cumplimiento del protocolo
    coreA.core_cache.print_cache_state("Core A");
    coreB.core_cache.print_cache_state("Core B");

    // Core A intenta escribir en el mismo dato (debe pasar a Modified M en Core A y Invalid I en Core B)
    coreA.store(0, address, memory, system_bus);

    // Imprimir estados para verificar el cumplimiento del protocolo
    coreA.core_cache.print_cache_state("Core A");
    coreB.core_cache.print_cache_state("Core B");

    // Core B intenta leer el dato después de invalidación (debe pasar a Owner O en Core A y Shared S en Core B)
    coreB.load(0, address, memory, system_bus);

    // Imprimir estados para verificar el cumplimiento del protocolo
    coreA.core_cache.print_cache_state("Core A");
    coreB.core_cache.print_cache_state("Core B");
    
    //system_bus.print_bus_state();

    return 0;
}
