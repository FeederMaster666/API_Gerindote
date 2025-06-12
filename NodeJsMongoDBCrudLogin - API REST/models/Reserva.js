const mongoose = require('mongoose');
const { Schema } = mongoose;

const reservaSchema = new Schema({
  espacio: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'espacio', 
    required: true 
  },
  franjaHoraria: { type: Date, required: true },
  estado: { type: String, enum: ['aceptada', 'cancelada'], default: 'aceptada' },
  usuario: { type: mongoose.Schema.Types.ObjectId, ref: 'user', required: true },
});

module.exports = mongoose.model('reserva', reservaSchema);