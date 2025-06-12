const mongoose = require('mongoose');
const { Schema } = mongoose;

const reservaActividadSchema = new Schema({
    usuario: { type: mongoose.Schema.Types.ObjectId, ref: 'user', required: true },
    actividad: { type: mongoose.Schema.Types.ObjectId, ref: 'actividad', required: true },
    fechaReserva: { type: Date, default: Date.now },
    estado: { 
    type: String, 
    enum: ['confirmada', 'cancelada'], 
    default: 'confirmada'
    },
    estadoPago: { 
    type: String, 
    enum: ['pendiente', 'pagado'], 
    default: 'pendiente'
    }
});

module.exports = mongoose.model('reservaActividad', reservaActividadSchema);