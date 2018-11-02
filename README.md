# ThreeOmegaMethod.jl

[![The MIT License](https://img.shields.io/badge/license-MIT-orange.svg?style=flat-square)](http://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.com/lnacquaroli/ThreeOmegaMethod.jl.svg?branch=master)](https://travis-ci.com/lnacquaroli/ThreeOmegaMethod.jl)

Simulation of the temperature rise response to the sinusoidal heating excitation through a metallic heater atop a system of thin films multilayer using a matrix formalism. The thermal response is given for a range of frequency which is determined by the electrical current excitation source. We consider a heater placed at the top of the system and a semi-infinite boundary condition on the substrate. For further details see [https://arxiv.org/abs/1809.07708](https://arxiv.org/abs/1809.07708).

## Installation

This package is not yet registered. It can be installed in Julia with the following ([see further](https://docs.julialang.org/en/v1/stdlib/Pkg/index.html#Adding-unregistered-packages-1)):
```julia
julia> ]
(v1.0) pkg> add https://github.com/lnacquaroli/ThreeOmegaMethod.jl
```

`ThreeOmegaMethod.jl` is compatible with Julia version 1.0 or later, and uses [`QuadGK.jl`](https://github.com/JuliaMath/QuadGK.jl) to perform numerical integration.

See the examples folder to start using the script.

## Usage

To call the main program we can do as follow:

```julia
ΔT, int_error = ThreeOmegaMatrix(layers, hgeometry, source, thresistances, int_limit=1.0e6)
```

Where `ThreeOmegaMatrix` is the main function exported from the module `ThreeOmegaMethod.jl`.

## Input arguments

### LayerInformation type

`layers::Array{Layer}` is an array that contains the sequence of layers that compose the thin film multilayer system. Each layer is constructed using the `Layer <: LayerInformation` subtype exported from the main module using the required information. For instance, we can construct different layers as follow calling `layer1 = Layer(ky, kxy, d, ρC)`, where the parameters required to calculate the thermal response are explained below.
```julia
heater = Layer(ky_1, kxy_1, d_1, ρC_1)
substrate = Layer(ky_2, kxy_2, d_2, ρC_2)
specimen = Layer(ky_3, kxy_3, d_3, ρC_3)
layers = [heater specimen substrate]
```

#### Cross-plane thermal conductivity

`ky::Float64` is the thermal conductivity of the layer, in units of Watt/meter/Kelvin.

#### In-plane/Cross-plane thermal conductivities ratio

`kxy::Float64` is the ratio between the in-plane to cross-plane thermal conductivities. It is a dimenionless number. This is the parameter that accounts for the 2D heat conduction.

#### Thickness

`d::Float64` defines the physical thickness of the layer in units of meter.

#### Heat capacitance

`ρC::Float64` is the product of the material density (kg per cubic meter) times the heat capacity (calories per degree).

### HeaterInformation type

This type contains the information about the geometry of the heater use to excite the films. The calling structure is `hgeometry = HeaterGeometry(b, l, ρh)`, where `HeaterGeometry <: HeaterInformation`. The method considers a planar geometry of the heater with defined width and length. The parameters are defined below.

#### Heater half-width

`b::Float64` is the heater half-width, in units of meter. The half-width appears naturally in the theory so it is a characteristic parameter instead of the width itself.

#### Heater length

`l::Float64` is the length of the heater, in units of meter. The length is defined, independently of the number of probes in the system, the distance between the pads used to measure the voltage drop, not those to drive the electrical current.

#### Heat capacitance of the heater

`ρh::Float64` is the product of the heater density (kg per cubic meter) times the heat capacity (calories per degree).

### HeaterSource type

This type wraps the electrical source power and the linear frequency range of the simulation. `source = Source(p, f)`, where `Source <: HeaterSource`. The parameters are defined below.

#### Electrical power

`p::Float64` is the peak power applied to the heater, in units of Watt. The power is defined as the product of the resistance at the temperature the measurements are taken times the squared electrical current that flows through the pads.

#### Frequency range

`f` is the frequency range in units of Hertz. The recommended way to define this parameters is in log-space. An easy way to do this is `f = exp10.(LinRange(f_initial, f_final, f_length))`. Notice that if you set the range in linear-space and then take a log-plot, results in a less convenient look of the simulation.

### Interface resistance

The method implemented here allows to input the resistances given by the interfaces between layers. `thresistances::Array{Float64,1}` sets the resistance for each interface in units of Kelvin*meter/Watt. The parameter is an `Array` where `lastindex(thresistances) == size(layers,2) - 1`.

### Integration limit

`int_limit::Float64` sets the upper integration limit for the numerical integration with `QuadGK` package. This is an optional parameter with default value of `1.0e6`.

## Output arguments

`ΔT::Array{ComplexF64,1}` is the temperature rise response calculated in the 2-omega mode.

`int_error::Array{Float64,1}` is the error returned from `QuadGK` process at each frequency.

## We welcome suggestions

If you have ideas and suggestions to improve `ThreeOmegaMethod.jl` in Julia, PRs and issues are welcomed.
