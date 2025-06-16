const mongoose = require('mongoose');
const { Schema } = mongoose;

const actividadSchema = new Schema({
    titulo: { type: String, required: true },
    descripcion: { type: String }, // Nuevo campo útil para web/app
    imagen: { type: String }, // URL de imagen destacada
    imagenes: [{ type: String }], // Lista de URLs de imágenes(para el carrusel de la app)
    plazasTotales: { type: Number}, // Reemplazar "aforo"
    plazasOcupadas: { type: Number}, // Control dinámico
    ubicacion: { type: String},//ubicacion de la actividad
    espacio: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'espacio',
        required: false // Algunas actividades no requieren espacio físico
    },
    fechaInicio: { type: Date, required: true }, // Más claro que fechaHora
    fechaFin: { type: Date},
    importe: { type: Number, default: 0 },//ATRIBUTO WEB
    pagoRequerido: { type: Boolean, default: false },//ATRIBUTO WEB
    aforo: {type: Number},//ATRIBUTO WEB
    usuario: {type: mongoose.Schema.Types.ObjectId, ref:'user'},//USUARIO CREADOR, ATRIVUTO WEB.
    pagoRequerido: { type: Boolean, default: false },//ATRIBUTO WEB


});

actividadSchema.methods.insert= async function () {
    //await this.save();
    await this.save()
    .then(result => console.log(result))
    .catch(error => console.log(error));
};

module.exports = mongoose.model('actividad', actividadSchema);
