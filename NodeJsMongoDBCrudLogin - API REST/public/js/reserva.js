const nombresBonitos = {
      "Pabellon": "Pabellón Polideportivo",
      "Pistas de padel": "Pistas de Pádel",
      "Pistas de tenis": "Pistas de Tenis",
      "Salon Cultural": "Salón Cultural"
    };

const horariosPorEspacio = {
  "Pabellon": [11, 12, 17, 18, 19, 20],
  "Pistas de padel": [17, 18, 19, 20],
  "Pistas de tenis": [17, 18, 19, 20], 
  "Salon Cultural": [11, 12, 17, 18, 19, 20] 
};

function getHoras(espacio) {
  const horas = [];
  const permitidas = horariosPorEspacio[espacio] || [11, 12, 17, 18, 19, 20];
  for (const h of permitidas) {
    horas.push({ inicio: h, fin: h + 1 });
  }
  return horas;
}

    function obtenerSemanaActual() {
      const hoy = new Date();
      hoy.setHours(0,0,0,0); // Solo fecha, sin hora
      const dias = [];
      for (let i = 0; i < 7; i++) {
        const d = new Date(hoy);
        d.setDate(hoy.getDate() + i);
        dias.push(d.toISOString().split('T')[0]);
      }
      return dias;
    }

    async function cargarEspacio() {
      const params = new URLSearchParams(window.location.search);
      let espacio = params.get('espacio');
      if (!espacio) {
        const res = await fetch('/api/espacios');
        const espacios = await res.json();
        if (espacios.length > 0) espacio = espacios[0].nombre;
      }
      // Si sigue sin valor, pon uno por defecto
      if (!espacio) espacio = "Pabellon";
      document.getElementById('espacio').value = espacio;
      document.getElementById('espacio-nombre').value = nombresBonitos[espacio] || espacio;
    }

    async function mostrarHorasSemana(fechas) {
      const container = document.getElementById('horas-horarias-container');
      const espacio = document.getElementById('espacio').value;
      const horas = getHoras(espacio);

      let reservas = [];
      try {
        const res = await fetch(`/api/reservas?espacio=${encodeURIComponent(espacio)}&fechas=${encodeURIComponent(JSON.stringify(fechas))}`);
        reservas = await res.json();
      } catch {}

      const reservadas = new Set(reservas.map(r => {
        const d = new Date(r.franjaHoraria);
        return d.toISOString().slice(0,16);
      }));

      let html = '<table class="horas-table"><thead><tr><th></th>';
      for (const fecha of fechas) {
        const d = new Date(fecha);
        const dias = ['Dom.', 'Lun.', 'Mar.', 'Mié.', 'Jue.', 'Vie.', 'Sáb.'];
        const meses = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
        const label = `${dias[d.getDay()]} ${d.getDate()} ${meses[d.getMonth()]}`;
        html += `<th>${label}</th>`;
      }
      html += '</tr></thead><tbody>';

      for (const bloque of horas) {
        const horaInicio = bloque.inicio.toString().padStart(2, '0') + ':00';
        const horaFin = bloque.fin.toString().padStart(2, '0') + ':00';
        html += `<tr><td class="hora-label">${horaInicio} – ${horaFin}</td>`;
        for (const fecha of fechas) {
          const keyISO = new Date(`${fecha}T${horaInicio}`).toISOString().slice(0,16);
          const reservado = reservadas.has(keyISO);
          html += `<td class="${reservado ? 'celda-reservada' : 'celda-disponible'}">`;
          if (reservado) {
            html += `<label>No disponible</label>`;
          } else {
            html += `<label>
              <input type="checkbox" class="hora-checkbox" value="${fecha}|${horaInicio}">
              Reservar
            </label>`;
          }
          html += '</td>';
        }
        html += '</tr>';
      }

      html += '</tbody></table>';
      container.innerHTML = html;

      document.querySelectorAll('.hora-checkbox').forEach(cb => {
        cb.addEventListener('change', function() {
          const td = cb.closest('td');
          td.classList.toggle('selected', cb.checked);
        });
      });
    }

    document.addEventListener('DOMContentLoaded', async () => {
      await cargarEspacio();

      const diasSemana = obtenerSemanaActual();
      document.getElementById('fechas-semana').value = diasSemana.join(',');
      mostrarHorasSemana(diasSemana);

      document.getElementById('form-reserva').onsubmit = async function(e) {
        e.preventDefault();
        const espacio = document.getElementById('espacio').value;
        const fechas = diasSemana;
        const msg = document.getElementById('reserva-msg');
        msg.textContent = '';

        // Comprobar si está autenticado
        if (typeof window.AUTHENTICATED !== "undefined" && !window.AUTHENTICATED) {
          msg.textContent = 'Debes iniciar sesión para reservar.';
          msg.style.color = 'red';
          return;
        }

        const checks = document.querySelectorAll('.hora-checkbox:checked');
        if (!fechas.length || !checks.length || !espacio) {
          msg.textContent = 'Por favor, selecciona al menos una franja horaria.';
          msg.style.color = 'red';
          return;
        }

        // Solo permitimos reservar una franja por pago (puedes adaptarlo para varias)
        if (checks.length > 1) {
          msg.textContent = 'Solo puedes reservar una franja por pago.';
          msg.style.color = 'red';
          return;
        }

        // Prepara los datos para Stripe
        const [fecha, hora] = checks[0].value.split('|');
        const res = await fetch('/api/stripe/create-checkout-session', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ espacio, fecha, hora })
        });
        const data = await res.json();
        if (data.url) {
          window.location = data.url; // Redirige a Stripe Checkout
        } else {
          msg.textContent = 'Error al iniciar el pago.';
          msg.style.color = 'red';
        }
      };
    });

    document.addEventListener('DOMContentLoaded', () => {
  const params = new URLSearchParams(window.location.search);
  if (params.get('success') === '1') {
    const msg = document.getElementById('reserva-msg');
    msg.textContent = '¡Reserva exitosa! Gracias por tu pago.';
    msg.style.color = 'green';
    // Opcional: limpiar la URL para que no se repita el mensaje al recargar
    
  }
});