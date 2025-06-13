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
    plazasReservadas: { type: Number, required: true }, // Control dinámico
    estadoPago: { 
    type: String, 
    enum: ['pendiente', 'pagado'], 
    default: 'pendiente'
    },
    metodoPago: {
        type: String,
        enum: ['efectivo', 'online'],
        default: 'efectivo'
    },
    //un campo para el id del pago de Stripe por si hace falta
    stripePaymentIntentId: { type: String }
});

module.exports = mongoose.model('reservaActividad', reservaActividadSchema);