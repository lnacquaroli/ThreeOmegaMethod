# half-width of heater line [m]
b = (12.5/2)*1e-6
# length of heater line [m]
l = 1.0e-3
# range of frequencies [Hz]
f = exp10.(LinRange(0, 9, 1500))
# power [W]
p = 0.030^2*22.11
# heater thermal resistance
ρh = [0. 0.] # I only need two actually, see F
# interface thermal resistances
thresistances = [0.]

# Wrap them into structures
heater = Layer(310.0, 1.0, 0.2e-6, 2.441e6)
substrate = Layer(160.0, 1.0, 525.0e-6, 2320*700.)
layers = [heater substrate]
hgeometry = HeaterGeometry(b, l, ρh)
source = Source(p, f)

# call the model
ΔT, int_error = ThreeOmegaMatrix(layers, hgeometry, source, thresistances)

