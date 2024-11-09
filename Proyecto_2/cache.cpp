#include "cache.h"

// Constructor
cache::cache() {
    index = 0;
    data.fill(0);
    addresses.fill(0);
    moesi_state.fill("I");  // Inicializa todos los bloques en estado "I" (Inválido)
    bus_access_enabled = true;
    cache_misses = 0;
    invalidations = 0;
}

void cache::read(int block, uint64_t addr,  bus bus) {
    if (moesi_state[block] == "I") {  // Si el bloque está en estado inválido
        cache_misses++;

        uint64_t data_m = bus.read_request(addr, index, block);

        moesi_state[block] = "S";  // Cambia el estado a compartido después de cargar
        data[block] = data_m;  // Carga el dato desde la memoria
        bus.read_requests++;
        bus.data_transmitted += 64;  // Se transmiten 64 bits
    }
}



void cache::write(int block, uint64_t addr, uint64_t data, bus bus) {
    if (moesi_state[block] == "I" || moesi_state[block] == "S") {
        moesi_state[block] = "M";  // Modificamos el bloque
    }
    this->data[block] = data;  // Guardar en cache
    bus.write_requests++;
}

// Imprimir el estado de cada bloque en la cache
void cache::print_cache_state(const std::string &core_name) {
    std::cout << "Estado de la cache del " << core_name << ":\n";
    for (int i = 0; i < 8; ++i) {
        std::cout << "Bloque " << i << " - MOESI: " << moesi_state[i] << "\n";
    }
}
