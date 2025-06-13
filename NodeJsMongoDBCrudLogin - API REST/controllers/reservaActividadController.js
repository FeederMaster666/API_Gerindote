    const Reserva = require('../models/reservaActividad');
    const Actividad = require('../models/Actividad');
    const stripe = require('stripe')('TU_SK_DE_STRIPE'); // Pon tu clave secreta aquí

    // Crear reserva
    exports.crearReserva = async (req, res) => {
    try {
        const { usuario, actividad, plazasReservadas, metodoPago } = req.body;

        // 1. Validar datos
        if (!usuario || !actividad || !plazasReservadas || plazasReservadas < 1) {
        return res.status(400).json({ message: 'Datos incompletos' });
        }

        // 2. Buscar la actividad
        const actividadObj = await Actividad.findById(actividad);
        if (!actividadObj) {
        return res.status(404).json({ message: 'Actividad no encontrada' });
        }

        // 3. Calcular plazas ocupadas actuales
        const reservasConfirmadas = await Reserva.aggregate([
        { $match: { actividad: actividadObj._id, estado: 'confirmada' } },
        { $group: { _id: null, total: { $sum: '$plazasReservadas' } } }
        ]);
        const plazasOcupadas = reservasConfirmadas[0]?.total || 0;
        const plazasDisponibles = actividadObj.plazasTotales - plazasOcupadas;

        if (plazasReservadas > plazasDisponibles) {
        return res.status(400).json({ message: 'No hay plazas suficientes disponibles' });
        }

        // 4. Si método de pago es online, crear PaymentIntent de Stripe
        let stripePaymentIntentId = null;
        if (metodoPago === 'online') {
        // Aquí puedes definir el precio por plaza:
        const precioPorPlaza = 500; // en céntimos (por ejemplo, 5€)
        const paymentIntent = await stripe.paymentIntents.create({
            amount: plazasReservadas * precioPorPlaza,
            currency: 'eur',
            metadata: {
            usuario,
            actividad,
            plazasReservadas
            }
        });
        stripePaymentIntentId = paymentIntent.id;
        }

        // 5. Crear la reserva en estado pendiente de pago si es online, o confirmada si es efectivo
        const reserva = new Reserva({
        usuario,
        actividad,
        plazasReservadas,
        estado: metodoPago === 'online' ? 'confirmada' : 'confirmada',
        estadoPago: metodoPago === 'online' ? 'pendiente' : 'pendiente',
        metodoPago,
        stripePaymentIntentId
        });

        await reserva.save();

        res.status(201).json({
        message: 'Reserva creada correctamente',
        reserva,
        stripeClientSecret: stripePaymentIntentId ? (await stripe.paymentIntents.retrieve(stripePaymentIntentId)).client_secret : null
        });
    } catch (error) {
        res.status(500).json({ message: 'Error al crear la reserva', error: error.message });
    }
    };

    // Confirmar pago Stripe (webhook o endpoint)
    exports.confirmarPagoStripe = async (req, res) => {
    // Aquí deberías validar el evento de Stripe y actualizar el estadoPago de la reserva
    // Ejemplo básico:
    const { paymentIntentId } = req.body;
    const reserva = await Reserva.findOne({ stripePaymentIntentId: paymentIntentId });
    if (reserva) {
        reserva.estadoPago = 'pagado';
        await reserva.save();
        res.json({ message: 'Pago confirmado y reserva actualizada' });
    } else {
        res.status(404).json({ message: 'Reserva no encontrada' });
    }
    };

    // Cancelar reserva
    exports.cancelarReserva = async (req, res) => {
    try {
        const { reservaId } = req.params;
        const reserva = await Reserva.findById(reservaId);
        if (!reserva) return res.status(404).json({ message: 'Reserva no encontrada' });

        if (reserva.estado === 'cancelada') {
        return res.status(400).json({ message: 'La reserva ya está cancelada' });
        }

        reserva.estado = 'cancelada';
        await reserva.save();

        res.json({ message: 'Reserva cancelada correctamente' });
    } catch (error) {
        res.status(500).json({ message: 'Error al cancelar la reserva', error: error.message });
    }
    };

    // Listar reservas por usuario
    exports.getReservasUsuario = async (req, res) => {
    const { usuarioId } = req.params;
    const reservas = await Reserva.find({ usuario: usuarioId }).populate('actividad');
    res.json(reservas);
    };

    // Listar reservas por actividad
    exports.getReservasActividad = async (req, res) => {
    const { actividadId } = req.params;
    const reservas = await Reserva.find({ actividad: actividadId }).populate('usuario');
    res.json(reservas);
    };
