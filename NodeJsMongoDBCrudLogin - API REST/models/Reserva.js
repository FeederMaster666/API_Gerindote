const mongoose = require('mongoose');
const { Schema } = mongoose;

const reservaSchema = new Schema({
    franjaHoraria: { type: Date, default: Date.now },
    estado: {type: String, enum: ['aceptada', 'cancelada'], default: 'aceptada' },
    usuario: {type: mongoose.Schema.Types.ObjectId, ref:'user'},
});

reservaSchema.methods.insert= async function () {
    //await this.save();
    await this.save()
    .then(result => console.log(result))
    .catch(error => console.log(error));
};

module.exports = mongoose.model('reserva', reservaSchema);