const mongoose = require('mongoose');
const { Schema } = mongoose;

const inscripcionSchema = new Schema({
    usuario: { type: mongoose.Schema.Types.ObjectId, ref: 'user', required: true },
    actividad: { type: mongoose.Schema.Types.ObjectId, ref: 'actividad', required: true },
    metodoPago: { type: String, enum: ['efectivo', 'stripe'], required: true },
    fechaInscripcion: { type: Date, default: Date.now }
});

module.exports = mongoose.model('inscripcion', inscripcionSchema);