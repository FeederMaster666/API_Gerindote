const mongoose = require('mongoose');
const { Schema } = mongoose;

const actividadSchema = new Schema({
    name: {type: String, required: true },
    usuario: {type: mongoose.Schema.Types.ObjectId, ref:'user'},
    aforo: {type: Number, required: true },
    espacio: {type: mongoose.Schema.Types.ObjectId, ref:'espacio'},
    fechaHora: { type: Date, default: Date.now },
});

actividadSchema.methods.insert= async function () {
    //await this.save();
    await this.save()
    .then(result => console.log(result))
    .catch(error => console.log(error));
};

module.exports = mongoose.model('actividad', actividadSchema);
