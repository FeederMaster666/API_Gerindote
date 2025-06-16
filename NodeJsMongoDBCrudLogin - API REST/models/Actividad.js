const mongoose = require('mongoose');
const { Schema } = mongoose;

const actividadSchema = new Schema({
    name: { type: String},
    usuario: {type: mongoose.Schema.Types.ObjectId, ref:'user'},
    aforo: {type: Number},
    descripcion: { type: String }, // Nuevo campo útil para web/app
    imagen: { type: String }, // URL de imagen destacada
    imagenes: [{ type: String }], // Lista de URLs de imágenes(para el carrusel de la app)
    plazasTotales: { type: Number }, // Reemplazar "aforo"
    plazasOcupadas: { type: Number }, // Control dinámico
    ubicacion: { type: String },//ubicacion de la actividad
    espacio: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'espacio',
        required: false // Algunas actividades no requieren espacio físico
    },
    fechaHora: { type: Date, default: Date.now },
    fechaFin: { type: Date,  }
});

actividadSchema.methods.insert= async function () {
    //await this.save();
    await this.save()
    .then(result => console.log(result))
    .catch(error => console.log(error));
};

module.exports = mongoose.model('actividad', actividadSchema);
