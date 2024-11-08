#include "bus.h"
#include <iostream>

// Constructor del bus
bus::bus() {
    // Inicializar puertos de dirección y datos a cero
    address_port.fill(0);
    data_port.fill(0);
    read_requests = 0;
    write_requests = 0;
    invalidations = 0;
    data_transmitted = 0;
}

// Función para manejar una solicitud de lectura en el bus
uint64_t bus::read_request(uint64_t address, uint64_t data, uint64_t cache_index, uint64_t cache_block) {
    read_requests++;
    // Verificar si el dato está en el puerto de direcciones
    if (address < 256) {
        update_moesi_state(address, data, cache_index, cache_block);
        return data_port[address];
        std::cout << "Bus: Lectura completada en la direccion " << address << " con el dato " << data_port[address] << std::endl;
    } else {
        std::cout << "Bus: Error en la solicitud de lectura. Dirección no encontrada " << address << std::endl;
    }
}

// Función para manejar una solicitud de escritura en el bus
void bus::write_request(uint64_t address, uint64_t data, uint64_t cache_index, uint64_t cache_block) {
    write_requests++;
    data_port[address] = data;
    data_transmitted += sizeof(data);
    update_moesi_state(address, data, cache_index, cache_block);
    std::cout << "Bus: Escritura completada en la dirección " << address << " con el dato " << data_port[address] << std::endl;
}


// Función para actualizar el estado MOESI en el bus
void bus::update_moesi_state(uint64_t address, uint64_t data, uint64_t cache_index, uint64_t cache_block) {
    // Estado actual del bloque en la caché de origen
    std::string& current_state = connected_caches[cache_index].moesi_state[cache_block];
    
    // Recorrer todas las cachés conectadas para aplicar el protocolo MOESI
    for (int i = 0; i < connected_caches.size(); ++i) {
        // Omitimos la caché de origen
        if (i == cache_index) continue;

        std::string& other_state = connected_caches[i].moesi_state[cache_block];
        
        // Transiciones de estado según el protocolo MOESI
        if (current_state == "I") {
            // Caso de lectura inicial en caché
            if (other_state == "I") {
                current_state = "E";  // Estado pasa a "Exclusive" si es la primera caché en cargar el dato
            } else {
                current_state = "S";  // Estado pasa a "Shared" si otros núcleos tienen el dato
                other_state = "S";
            }
        } else if (current_state == "E" || current_state == "S") {
            // Caso donde otra caché lee el dato
            if (other_state == "I") {
                other_state = "S";  // Cambiamos el estado a "Shared" en la caché que realiza la lectura
            }
            current_state = "S";  // Cambiamos el estado de la caché de origen a "Shared"
        } else if (current_state == "M") {
            // Caso de modificación del dato
            other_state = "I";  // Invalidamos el bloque en otras cachés
            current_state = "M";  // La caché de origen se mantiene en "Modified"
        } else if (current_state == "S" && other_state == "I") {
            // Si una caché con estado S intenta modificar el dato
            current_state = "M";  // Cambia su estado a "Modified"
            invalidations++;  // Incrementa el contador de invalidaciones
        } else if (current_state == "M" && other_state == "S") {
            // Lectura desde otra caché cuando el estado es "Modified"
            current_state = "O";  // Cambiamos a "Owner" para indicar que se compartirá el dato
            other_state = "S";  // El otro bloque pasa a "Shared"
        }
    }

    std::cout << "Bus: Estado MOESI actualizado para caché " << cache_index << ", bloque " << cache_block 
              << " a " << current_state << std::endl;
}


// Función para imprimir el estado del bus
void bus::print_bus_state() const {
    std::cout << "Estado del Bus:\n";
    std::cout << "Read Requests: " << read_requests << "\n";
    std::cout << "Write Requests: " << write_requests << "\n";
    std::cout << "Invalidations: " << invalidations << "\n";
    std::cout << "Data Transmitted: " << data_transmitted << " bytes\n";
}
