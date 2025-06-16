const mongoose = require('mongoose');
const { Schema } = mongoose;

const espacioSchema = new Schema({
    nombre: {type: String, required: true, unique:true},
    estado:{type: Boolean, default: null},
}, {timestamps: true});// timestamps: true añade createdAt y updatedAt automáticamente


espacioSchema.methods.insert= async function () {
    //await this.save();
    await this.save()
    .then(result => console.log(result))
    .catch(error => console.log(error));
  };

espacioSchema.statics.initDefaultEspacios = async function () {
    
    const requiredEspacios = [
        { nombre: 'Pabellon Municipal' },
        { nombre: 'Pistas de padel' },
        { nombre: 'Pistas de tenis' },
        { nombre: 'Salon Cultural' },
        { nombre: 'Campo de fútbol' },
        { nombre: 'Gimnasio Municipal' },
        { nombre: 'Piscina Municipal' },
        { nombre: 'Pistas Exteriores' }
    ];

    
    const espacios = [
        { nombre: 'Pabellon' },
        { nombre: 'Pistas de padel' },
        { nombre: 'Pistas de tenis' },
        { nombre: 'Salon Cultural' },
        { nombre: 'Sala de reuniones' },
        { nombre: 'Sala de estudio' },
        { nombre: 'Gimnasio' },
        { nombre: 'Auditorio' },
        { nombre: 'Sala de conferencias' },
        { nombre: 'Sala de exposiciones' },
        { nombre: 'Zona recreativa' },
        { nombre: 'Parque infantil' },
        { nombre: 'Cancha de baloncesto' },
        { nombre: 'Cancha de voleibol' },
        { nombre: 'Campo de fútbol' },
        { nombre: 'Mesa ping pong' }
    ];

    // Añadir los espacios requeridos si no están ya en la lista
    for (const reqEsp of requiredEspacios) {
        if (!espacios.some(e => e.nombre === reqEsp.nombre)) {
            espacios.push(reqEsp);
        }
    }
    for (const esp of espacios) {
        await this.findOneAndUpdate(
            { nombre: esp.nombre },
            esp,
            { upsert: true, new: true, setDefaultsOnInsert: true }
        );
    }
};

module.exports = mongoose.model('espacio', espacioSchema);