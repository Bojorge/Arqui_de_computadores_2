#include "bus.h"
#include "core.h"
#include "ram.h"
#include <thread>

int main() {
    bool moesi_protocol = false;

    RAM ram;
    core core0(0, moesi_protocol); 
    core core1(1, moesi_protocol); 
    core core2(2, moesi_protocol);
    core core3(3, moesi_protocol);
    bus bus(core0, core1, core2, core3, ram);
    
    // Crear hilos para ejecutar el método start en cada core
    std::vector<std::thread> threads;
    threads.emplace_back(&core::start, &core0, std::ref(bus));
    threads.emplace_back(&core::start, &core1, std::ref(bus));
    threads.emplace_back(&core::start, &core2, std::ref(bus));
    threads.emplace_back(&core::start, &core3, std::ref(bus));


    // Esperar a que todos los hilos terminen
    for (auto& thread : threads) {
        thread.join();
    }

    // Imprimir estados para verificar el cumplimiento del protocolo
    core0.core_cache.print_cache_state("Core 0");
    core1.core_cache.print_cache_state("Core 1");
    core2.core_cache.print_cache_state("Core 2");
    core3.core_cache.print_cache_state("Core 3");

    return 0;
}
