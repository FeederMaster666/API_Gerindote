const mongoose = require('mongoose');
const { Schema } = mongoose;

const reservaSchema = new Schema({
    espacio: {
        type: String,
        enum: ['Pabellon', 'Pistas de padel', 'Pistas de tenis', 'Salon Cultural'],
        required: true
    },
    franjaHoraria: { type: Date, required: true },
    estado: { type: String, enum: ['aceptada', 'cancelada'], default: 'aceptada' },
    usuario: { type: mongoose.Schema.Types.ObjectId, ref: 'user', required: true },
});

reservaSchema.methods.insert = async function () {
    await this.save()
        .then(result => console.log(result))
        .catch(error => console.log(error));
};

module.exports = mongoose.model('reserva', reservaSchema);