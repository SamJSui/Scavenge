#ifndef SCAVENGE_PSO_H
#define SCAVENGE_PSO_H

#include "config.cuh"
#include "cuda_interface.cuh"
#include "particle.cuh"
#include "vec2.cuh"
#include "utils_types.h"

SCAVENGE_NAMESPACE_BEGIN

__device__ __constant__ float dev_params[3]; // Simulation Parameters

/* Global (CUDA Kernel) / Device Helper Functions */

namespace pso {

  __host__ __device__ float test_fn(scavenge::vec2);
  extern __global__ void update_particle_position_gpu();
  extern __global__ void update_particle_velocity_gpu();
  extern __global__ void update_global_best_gpu();

}

/* PSO Core Class Declaration */

class PSO {

  public:

    PSO(const unsigned int=40, const float=0.5, const float=1.0, const float=1.0);
    ~PSO();

    /* Overloaded Operators */

    Particle& operator[](const unsigned int&);
    
    /* Public PSO Simulation Functions*/

    void run(const unsigned int=1000);

    /* PSO Setters */
    
    void set_gpu(const bool&);

    /* PSO Simulation Parameters */

    float params[3];

  private:

    /* Device-side Constructor */

    void device_init();

    /* CPU Simulation */

    void simulate_cpu();
    void update_particle_position();
    void update_particle_velocity();
    void update_global_best();

    /* GPU Simulation */

    void simulate_gpu();

    /* Maintains GPU settings and epochs */

    Config settings_;

    /* Particles */

    Particle *particles_;
    Particle *dev_particles_;

    /* Parameters for Simulation */

    const unsigned int num_particles_;

    /* Simulation Global Best */

    float best_fitness_;
    unsigned int best_idx_;
};

SCAVENGE_NAMESPACE_END

#endif // SCAVENGE_PSO_H