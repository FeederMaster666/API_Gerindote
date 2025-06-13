var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
const session = require('express-session');
const passport = require('passport');
const logger = require('morgan');
const cors = require('cors');
const MongoStore = require('connect-mongo');
const fs = require("fs");

var app = express();
require('./database');
require('./passport/local-auth');

var tasksRouter = require('./routes/tasks');
var usersRouter = require('./routes/users');
var noticiasRouter = require('./routes/noticias');
var userController = require('./controllers/userController');
const espaciosRouter = require('./routes/espacios'); // Añadido

// view engine setup
app.set('port', process.env.PORT || 5500);

// Middlewares
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

// Sesiones
app.use(session({
  secret: 'mysecretsession',
  resave: false,
  saveUninitialized: false,
  cookie: { secure: false } // solo true si usas HTTPS
}));

app.use(passport.initialize());
app.use(passport.session());

// CORS
app.use(cors({
  origin: [
    'http://127.0.0.1:5500', // Web
    'http://192.168.1.131:5500', // Dirección de tu móvil en desarrollo
    'http://localhost:5500' // Emuladores
  ], // tu frontend
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));

// Variable global user
app.use((req, res, next) => {
  console.log("🟢 Usuario autenticado:", req.user);
  app.locals.user = req.user;
  next();
});

// Rutas API
app.use('/api/users', usersRouter);
app.use('/api/tasks', tasksRouter);
app.use('/api/noticias', noticiasRouter);
app.use('/api/espacios', espaciosRouter); // Añadido
const reservasRouter = require('./routes/reservas'); // ⛔ Falta
app.use('/api/reservas', reservasRouter);
app.use('/imagenPortadaNoticias', express.static(path.join(__dirname,'..', 'imagenPortadaNoticias')));
// Endpoint para info de sesión (autenticación y rol)
app.get('/api/users/session-info', userController.sessionInfo);

// RENDER personalizado para "/index.html"
app.get("/index.html", (req, res) => {
  const authenticated = !!req.user;
  const role = req.user && req.user.role ? req.user.role : null;

  let html = fs.readFileSync(path.join(__dirname, "public", "index.html"), "utf8");

  html = html.replace(
    "</head>",
    `<script>
      window.AUTHENTICATED = ${JSON.stringify(authenticated)};
      window.USER_ROLE = ${JSON.stringify(role)};
    </script>\n</head>`
  );

  res.send(html);
});

// Resto de archivos estáticos
app.use(express.static(path.join(__dirname, 'public')));

// 404
app.use((req, res, next) => {
  res.status(404).json({ message: "Route not found" });
});

// 500
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: "Internal server error", error: err.message });
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
  console.log(`✅ Server running at http://localhost:${PORT}`);
});

module.exports = app;
