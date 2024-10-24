#include <vector>
#include <array>
#include <cstdint>
#include <string>
#include <iostream>
#include <thread>

struct RAM {
    std::array<uint64_t, 256> memory;  // Memoria del sistema con 256 posiciones de 64 bits
};

struct instruction_memory {
    std::vector<std::string> instructions;    // Memoria de instrucciones de cada core (código)
};

struct bus {
    std::array<uint64_t, 256> address_port;  // Puerto de direcciones (conectado a RAM y cores)
    std::array<uint64_t, 256> data_port;     // Puerto de datos (conectado a RAM y cores)
    std::string moesi_port;  // Puerto compartido para estados MOESI entre caches de cores

    // Contadores para eventos del bus
    int read_requests = 0;
    int write_requests = 0;
    int invalidations = 0;
    uint64_t data_transmitted = 0;
};

struct cache {
    std::array<uint64_t, 8> data;             // 8 bloques de datos
    std::array<uint64_t, 8> addresses;        // Direcciones correspondientes
    std::array<std::string, 8> moesi_state;   // Estados MOESI por bloque
    bool bus_access_enabled = true;           // Acceso habilitado al bus
    int cache_misses = 0;
    int invalidations = 0;

    // Constructor para inicializar el estado MOESI
    cache() {
        for (int i = 0; i < 8; ++i) {
            moesi_state[i] = "I";  // Inicializamos todos los bloques en "Invalid"
        }
    }

    // Simulación de coherencia MOESI en una operación de carga
    void load(int block, uint64_t addr, RAM &memory, bus &system_bus) {
        if (moesi_state[block] == "I") {
            cache_misses++;
            moesi_state[block] = "S";  // Asumimos estado compartido después de cargar
            data[block] = memory.memory[addr];
            system_bus.read_requests++;
            system_bus.data_transmitted += 64;  // Transmitimos 64 bits
        }
    }

    // Simulación de coherencia MOESI en una operación de almacenamiento
    void store(int block, uint64_t addr, RAM &memory, bus &system_bus) {
        if (moesi_state[block] == "I" || moesi_state[block] == "S") {
            moesi_state[block] = "M";  // Modificamos el bloque
        }
        data[block] = memory.memory[addr];  // Guardar en cache
        system_bus.write_requests++;
    }

    // Función para imprimir el estado de cada bloque en la cache
    void print_cache_state(const std::string &core_name) {
        std::cout << "Estado de la cache del " << core_name << ":\n";
        for (int i = 0; i < 8; ++i) {
            std::cout << "Bloque " << i << " - MOESI: " << moesi_state[i] << "\n";
        }
    }
};

struct core {
    cache core_cache;                         // Cada core tiene su propia memoria cache
    std::array<uint64_t, 4> registers;        // 4 registros de 64 bits: REG0, REG1, REG2, REG3

    // Función para cargar datos desde RAM a un registro usando MOESI
    void load(int reg, uint64_t addr, RAM &memory, bus &system_bus) {
        int cache_block = addr % 8;  // Determinar el bloque de cache
        core_cache.load(cache_block, addr, memory, system_bus);
        registers[reg] = core_cache.data[cache_block];
    }

    // Función para almacenar datos de un registro en RAM usando MOESI
    void store(int reg, uint64_t addr, RAM &memory, bus &system_bus) {
        int cache_block = addr % 8;  // Determinar el bloque de cache
        core_cache.store(cache_block, addr, memory, system_bus);
        memory.memory[addr] = registers[reg];
    }

    // Incrementar el valor en un registro (INC)
    void inc(int reg) {
        registers[reg]++;
    }

    // Decrementar el valor en un registro (DEC)
    void dec(int reg) {
        registers[reg]--;
    }

    // Salto condicional si el valor en el registro no es cero (JNZ)
    void jnz(int reg, std::string label, instruction_memory &inst_mem) {
        if (registers[reg] != 0) {
            // Implementación vacía
        }
    }
};

// Función para ejecutar un core
void execute_core(core &c, RAM &ram, bus &system_bus) {
    // Simulamos algunas operaciones de carga, almacenamiento y coherencia MOESI
    c.load(0, 10, ram, system_bus);  // Cargar memoria[10] en REG0
    c.inc(0);                        // Incrementar REG0
    c.store(0, 20, ram, system_bus); // Guardar REG0 en memoria[20]
}

int main() {
    RAM system_ram;
    bus system_bus;
    core core_0, core_1;

    // Inicializar memoria RAM
    for (int i = 0; i < 256; i++) {
        system_ram.memory[i] = i * 10;  // Valores iniciales en la memoria
    }

    // Crear hilos para ejecutar cores simultáneamente
    std::thread core_thread_0(execute_core, std::ref(core_0), std::ref(system_ram), std::ref(system_bus));
    std::thread core_thread_1(execute_core, std::ref(core_1), std::ref(system_ram), std::ref(system_bus));

    // Unir los hilos
    core_thread_0.join();
    core_thread_1.join();

    // Mostrar resultados básicos
    std::cout << "Número de peticiones de lectura: " << system_bus.read_requests << std::endl;
    std::cout << "Número de peticiones de escritura: " << system_bus.write_requests << std::endl;
    std::cout << "Cantidad de datos transmitidos: " << system_bus.data_transmitted << " bits" << std::endl;

    // Mostrar el estado MOESI de cada cache
    core_0.core_cache.print_cache_state("Core 0");
    core_1.core_cache.print_cache_state("Core 1");

    return 0;
}
