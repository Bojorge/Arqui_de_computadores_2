#include "core.h"

// Función para cargar datos desde RAM a un registro
void core::load(int reg, uint64_t addr) {
    int cache_block = addr % 8;  // Determinar el bloque de cache
    uint64_t data = 0;

    if(core_cache.moesi_state[cache_block] == "E"){
        data = core_cache.data[cache_block];
    }
    else if(core_cache.moesi_state[cache_block] == "O"){
        data = core_cache.data[cache_block];
    }
    else if(core_cache.moesi_state[cache_block] == "M"){

    }
    else if(core_cache.moesi_state[cache_block] == "S"){

    }
    else if(core_cache.moesi_state[cache_block] == "I"){

    }

    registers[reg] = data;
}

// Función para almacenar datos de un registro en RAM
void core::store(int reg, uint64_t cache_block, uint64_t data) {
    uint64_t addr = cache_block ;  
    core_cache.data[cache_block] = data;
    memory.memory[addr] = registers[reg];
}

// Incrementar el valor en un registro 
void core::inc(int reg) {
    registers[reg]++;
}

// Decrementar el valor en un registro 
void core::dec(int reg) {
    registers[reg]--;
}

// Salto condicional si el valor en el registro no es cero 
void core::jnz(int reg, std::string label, instruction_memory &inst_mem) {
    if (registers[reg] != 0) {
        // Implementación vacía
    }
}
