const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const User = require('../models/user'); // Asegúrate de que el modelo User esté correctamente definido
const bcrypt = require('bcryptjs');

passport.serializeUser((user, done) => {
  done(null, user.id);
});

passport.deserializeUser(async (id, done) => {
  const user = await User.findById(id);
  done(null, user);
});

passport.use('local-signup', new LocalStrategy({
  usernameField: 'email',
  passwordField: 'password',
  passReqToCallback: true
}, async (req, email, password, done) => {
  try {
    const user = await User.findOne({ email: email });
    if (user) {
      return done(null, false, { message: 'El correo ya está registrado' });
    } else {
      const hashedPassword = bcrypt.hashSync(password, 10); // Primero encripta la contraseña
      const newUser = new User({
        email,
        name: req.body.name,
        password: hashedPassword, // Ahora usa la contraseña encriptada
      });

      console.log("Usuario creado:", newUser);
      await newUser.save();
      return done(null, newUser);
    }
  } catch (err) {
    console.error("Error en local-signup:", err);
    return done(err);
  }
}));

passport.use('local-signin', new LocalStrategy({
  usernameField: 'email',
  passwordField: 'password',
  passReqToCallback: true
}, async (req, email, password, done) => {
  try {
    const user = await User.findOne({ email });
    if (!user) {
      return done(null, false, { message: 'Usuario no encontrado' });
    }
    if (!user.comparePassword(password)) { // Asegúrate de que tienes un método `comparePassword` en tu modelo User
      return done(null, false, { message: 'Contraseña incorrecta' });
    }
    return done(null, user);
  } catch (err) {
    return done(err);
  }
}));

module.exports = passport;
