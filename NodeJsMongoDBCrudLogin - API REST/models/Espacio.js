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
    const espacios = [
        { nombre: 'Pabellon' },
        { nombre: 'Pistas de padel' },
        { nombre: 'Pistas de tenis' },
        { nombre: 'Salon Cultural' }
    ];
    for (const esp of espacios) {
        await this.findOneAndUpdate(
            { nombre: esp.nombre },
            esp,
            { upsert: true, new: true, setDefaultsOnInsert: true }
        );
    }
};

module.exports = mongoose.model('espacio', espacioSchema);