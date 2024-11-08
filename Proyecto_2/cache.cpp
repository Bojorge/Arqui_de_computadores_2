#include "cache.h"

// Constructor para inicializar el estado MOESI
cache::cache() {
    for (int i = 0; i < 8; ++i) {
        moesi_state[i] = "I";  // Inicializamos todos los bloques en "Invalid"
    }
}


// Imprimir el estado de cada bloque en la cache
void cache::print_cache_state(const std::string &core_name) {
    std::cout << "Estado de la cache del " << core_name << ":\n";
    for (int i = 0; i < 8; ++i) {
        std::cout << "Bloque " << i << " - MOESI: " << moesi_state[i] << "\n";
    }
}
