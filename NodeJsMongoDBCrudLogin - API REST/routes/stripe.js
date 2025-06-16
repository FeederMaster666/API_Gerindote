const express = require('express');
const router = express.Router();
const Stripe = require('stripe');
const stripe = Stripe('d'); // pon aquí tu clave secreta de prueba

router.post('/create-checkout-session', async (req, res) => {
  const { espacio, fecha, hora } = req.body;
  // Si usas passport, req.user debería estar definido
  const userId = req.user ? req.user._id : null;
  if (!espacio || !fecha || !hora || !userId) {
    return res.status(400).json({ error: 'Faltan datos para la reserva' });
  }
  console.log('Datos recibidos en checkout:', { espacio, fecha, hora, userId });
  try {
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      mode: 'payment',
      line_items: [{
        price_data: {
          currency: 'eur',
          product_data: {
            name: `Reserva ${espacio} - ${fecha} ${hora}`,
          },
          unit_amount: 500,
        },
        quantity: 1,
      }],
      success_url: `http://localhost:3000/reservas.html?success=1&espacio=${encodeURIComponent(espacio)}&fecha=${encodeURIComponent(fecha)}&hora=${encodeURIComponent(hora)}`,
      cancel_url: 'http://localhost:3000/reservas.html?canceled=1',
      metadata: { espacio, fecha, hora, userId: userId.toString() }
    });
    res.json({ url: session.url });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/actividad-session', async (req, res) => {
  const { actividadId } = req.body;
  const userId = req.user ? req.user._id : null;

  if (!actividadId || !userId) {
    return res.status(400).json({ error: 'Faltan datos para la inscripción' });
  }

  const Actividad = require('../models/Actividad');
  try {
    const actividad = await Actividad.findById(actividadId);
    if (!actividad) {
      return res.status(404).json({ error: 'Actividad no encontrada' });
    }

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      mode: 'payment',
      line_items: [{
        price_data: {
          currency: 'eur',
          product_data: {
            name: `Inscripción: ${actividad.name}`,
          },
          unit_amount: 500, // Precio en céntimos (5€)
        },
        quantity: 1,
      }],
      success_url: `http://localhost:3000/deportes.html?inscrito=1&actividad=${actividadId}`,
      cancel_url: 'http://localhost:3000/deportes.html?canceled=1',
      metadata: {
        actividadId,
        userId: userId.toString()
      }
    });

    res.json({ url: session.url });
  } catch (err) {
    console.error('Error al crear sesión Stripe:', err.message);
    res.status(500).json({ error: 'Error en Stripe' });
  }
});

router.post('/webhook', async (req, res) => {
  console.log("Webhook recibido");
  const endpointSecret = 'd'; // Pon aquí tu secret real
  const sig = req.headers['stripe-signature'];
  let event;
  try {
    event = Stripe.webhooks.constructEvent(req.body, sig, endpointSecret);
  } catch (err) {
    console.error('Error de firma Stripe:', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  if (event.type === 'checkout.session.completed') {
  const session = event.data.object;
  const metadata = session.metadata || {};
  console.log('Webhook session.metadata:', metadata);

  const userId = metadata.userId;

  // RESERVA
  if (metadata.espacio && metadata.fecha && metadata.hora) {
    const { espacio, fecha, hora } = metadata;
    const Reserva = require('../models/Reserva');
    try {
      const reserva = await Reserva.create({
        espacio,
        franjaHoraria: new Date(`${fecha}T${hora}:00`),
        usuario: userId,
        estado: 'aceptada'
      });
      console.log('✅ Reserva creada vía Stripe:', reserva);
    } catch (err) {
      console.error('❌ Error al crear reserva en webhook:', err);
    }

  // INSCRIPCIÓN
  } else if (metadata.actividadId) {
    const { actividadId } = metadata;
    const Inscripcion = require('../models/inscripcion');
    const Actividad = require('../models/Actividad');

    try {
      const actividad = await Actividad.findById(actividadId);
      if (!actividad) {
        console.error('❌ Actividad no encontrada');
        return res.status(404).send('Actividad no encontrada');
      }

      if (actividad.aforo <= 0) {
        console.error('❌ No hay aforo disponible');
        return res.status(400).send('Aforo completo');
      }

      await Inscripcion.create({
        actividad: actividadId,
        usuario: userId,
        metodoPago: 'stripe'
      });

      actividad.aforo -= 1;
      await actividad.save();

      console.log('✅ Inscripción creada vía Stripe para actividad:', actividad.name);
    } catch (err) {
      console.error('❌ Error al crear inscripción:', err);
    }

  } else {
    console.warn('⚠️ Webhook recibido pero sin metadata relevante');
  }
}
  res.json({received: true});
});

module.exports = router;