const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const { Schema } = mongoose;

const userSchema = new Schema({
  name: {
    type: String,
    required: true // El nombre es obligatorio
  },
  apellidos: {
    type: String,
    required: false
  },
  email: {
    type: String,
    required: true,
    unique: true // No puede haber dos emails iguales
  },
  dni: {
    type: String,
    required: false,
    unique:true
  },
  password: {
    type: String,
    required: true
  },
  rol: {
    type: String,
    enum: ['admin', 'user'], // Solo puede ser 'admin' o 'user'
    default: 'user' // Por defecto es 'user'
  },
  isEmpadronado: {
    type: Boolean,
    default: false // Determina si está empadronado
  },
});

// Método para encriptar la contraseña antes de guardarla
userSchema.methods.encryptPassword = function(password) {
  return bcrypt.hashSync(password, 10);
};
// Método para comparar la contraseña ingresada con la almacenada
userSchema.methods.comparePassword = function(password) {
  return bcrypt.compareSync(password, this.password);
};

userSchema.methods.findEmail= async (email) => {
  const User = mongoose.model("user", userSchema);
  return  await User.findOne({'email': email})
  .then(result => {return result})
  .catch(error => console.log(error));

};


userSchema.methods.insert= async function () {
  //await this.save();
  await this.save()
  .then(result => console.log(result))
  .catch(error => console.log(error));
};


module.exports = mongoose.model('user', userSchema);
