# Decisiones de diseño: del teléfono al wearable y la TV

## Wearable (reloj inteligente circular, 384×384 px)

### Elementos eliminados del diseño de teléfono
1. **Pronóstico de 3 días**: en una pantalla de 384×384 no hay espacio para chips. Además, el usuario de un wearable busca el dato actual al instante (glanceability).
2. **Gráfico de temperatura horaria**: el reloj es demasiado pequeño para curvas legibles; además, en un reloj se prioriza la información inmediata sobre tendencias en esté caso temperatura.
3. **Barra de navegación inferior**: en wearables no hay barra de navegación convencional; la interacción es por gestos o crown.
4. **Botón de configuración y toggles**: eliminados porque las configuraciones se manejan desde el teléfono emparejado para evitar interacción tediosa en pantalla reducida.
5. **Texto secundario extendido** ("Soleado · H 24% · Viento 8 km/h"): reducido solo a ciudad e icono para maximizar legibilidad en 1 segundo.

### Elementos mantenidos
- Temperatura grande como dato principal (glanceability).
- Icono del clima para reconocimiento visual rápido.
- Nombre de la ciudad para contexto geográfico.

### Por qué
El diseño wearable debe cumplir la regla de los 3 elementos visibles simultáneamente y ser legible en 1 segundo (glanceability). Por eso se optó por jerarquía extrema: un número grande, un icono y un label corto. El color amarillo `#FFD166` sobre fondo oscuro `#0B1220` garantiza alto contraste (12.82:1) para lectura rápida bajo la luz del sol o en interiores.

---

## TV (pantalla inteligente, 1920×1080 px, 10-foot UI)

### Elementos eliminados del diseño de teléfono
1. **Temperatura gigante centrada**: en TV el usuario está a 3 metros, pero la interfaz debe mostrar más ciudades (dashboard), no una sola. La temperatura se reduce proporcionalmente dentro de cada tarjeta.
2. **Navegación táctil**: reemplazada por navegación D-pad (flechas arriba/abajo/izquierda/derecha y botón OK) porque el control remoto no tiene touch.
3. **Teclado de búsqueda de ciudad en pantalla**: para la TV se asume que la configuración se hace en otro dispositivo o mediante voz, por lo que no se incluye input de texto complejo.
4. **Scroll vertical continuo**: reemplazado por un grid de 4 tarjetas fijas navegables por D-pad, ya que el scroll libre con control remoto es incómodo.

### Elementos mantenidos
- Tarjetas con ciudad, temperatura e icono (patrón reconocible del teléfono).
- Paleta de colores oscura para reducir fatiga visual en salas con poca luz.

### Por qué
La TV requiere 10-foot UI: tipografía grande (temperatura ≥72 px, secundarios ≥36 px) y safe zone del 5% (96 px laterales, 54 px verticales) para evitar que el contenido se corte en televisores con overscan. Se agregó una nota de seguridad indicando que no se muestran datos sensibles sin autenticación, ya que la pantalla de TV es compartida y visible para múltiples personas.

---

## Conclusión
La adaptación no fue una simple reducción o ampliación de la interfaz del teléfono. Cada dispositivo impone restricciones de hardware (tamaño de pantalla, distancia de visualización, tipo de entrada) que obligan a re-pensar la jerarquía de información, la navegación y la seguridad.
