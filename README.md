# Dev Chart — Labo Los Alos

**Base de datos de tiempos de revelado para película B&N — código abierto**

> Desarrollado por **Labo Los Alos** · 2026  
> Licencia: **CC0 1.0 Universal** (dominio público)

---

## ¿Qué es esto?

Una base de datos completa y gratuita de tiempos de revelado para película fotográfica en blanco y negro, construida desde cero consultando únicamente **fuentes oficiales** de los fabricantes.

Incluye una **app web** lista para usar en Android (via Capacitor) y una **app Excel** con macros VBA para consulta de escritorio.

---

## Contenido del repositorio

| Archivo | Descripción |
|---|---|
| `films.json` | DB completa en formato JSON — 666 combinaciones |
| `labo-los-alos.html` | App web completa (funciona offline, Android via Capacitor) |
| `LaboLosAlos_DevChart_APP.xlsx` | App Excel con buscador visual |
| `LaboLosAlos_DevChart_Macros.bas` | Módulo VBA para combos en cascada |
| `LaboLosAlos_DevChart_DB.xlsx` | DB completa con 7 hojas (buscador, por revelador, Romek, temperaturas, etc.) |

---

## La base de datos

### Cifras

- **666 combinaciones** película × revelador × dilución
- **34 películas**
- **23 reveladores** (más 15 aliases documentados)
- **100% cobertura de push** (+1, +2, +3 para todas las combinaciones)
- **7 temperaturas** (18°C a 24°C) calculadas por compensación estándar

### Características únicas

- 🇦🇷 **Reveladores Romek Argentina** (PQ6, PQ7, PQ9, R09) — primera documentación pública conocida
- 📖 **Fuentes citadas** para cada dato — trazabilidad completa
- 🌡️ **Compensación de temperatura** integrada (±10% por °C, estándar Ilford/Kodak)
- 🔄 **Tres modos de agitación**: 30s estándar, Continuo (×0.85), Stand/Desatendido
- 📐 **Push calculados** con metodología Langford cuando no existe dato oficial

---

## Películas incluidas

Adox CHS 100 II · Adox Silvermax 100 · Bergger Pancro 400 · CineStill BwXX · Ferrania P30 · Foma Retropan 320 · Fomapan 100/200/400 · Fuji Neopan Acros 100 II · Ilford Delta 100/400/3200 · Ilford FP4 Plus · Ilford HP5 Plus · Ilford Kentmere 100/400 · Ilford Pan F Plus · Ilford SFX 200 · JCH Streetpan 400 · Kodak Double-X 5222 · Kodak Plus-X 125 · Kodak T-MAX 100/400 · Kodak Tri-X 400 · Kosmo Foto Mono 100 · Lomo Babylon Kino 13 · Lomo Berlin Kino 400 · Lomo Earl Grey 100 · Lomo Fantome Kino 8 · Lomo Lady Grey 400 · Lomo Potsdam Kino 100 · Rollei RPX 100/400

## Reveladores incluidos

D-76 · D-23 · D-96 · HC-110 · ID-11 · Ilfosol 3 · Ilfotec DD-X · Ilfotec HC · Ilfotec LC29 · Microphen · Microdol-X · Perceptol · Rodinal · T-MAX Dev · T-MAX RS · XTOL · **Romek PQ6 · Romek PQ7 · Romek PQ9 · Romek R09** · Adox Adonal · Adox Silvermax Dev · Foma Retro Special Dev

---

## Metodología

### Fuentes de datos

Todos los tiempos se obtuvieron de **datasheets oficiales de fabricantes**:

- **Kodak**: F-4017 (Tri-X, 2016), F-4016 (T-MAX 100), F-4043 (T-MAX 400), F-4018 (Plus-X), J-24 (HC-110)
- **Ilford / HARMAN Technology**: Film Processing Chart 2017, Ilfotec HC datasheet Feb 2025
- **Foma**: datasheets individuales + tabla de films extranjeros 09/16
- **Rollei / MACO**: datasheet 2021
- **Lomography**: guías oficiales de film (Lady Grey, Berlin, Potsdam, Earl Grey, Fantome, Babylon, Streetpan)
- **JCH**: carton oficial Streetpan 400
- **Kosmo Foto**: development chart oficial
- **Bergger / Firstcall Photographic**: datasheet oficial
- **Romek Argentina**: datos provistos directamente por Labo Los Alos
- **darkroom-solutions.com/notes**: tabla de equivalencias de reveladores

### Cálculo de push (cuando no hay dato oficial)

```
T_push = T_base × M^n
```

- `M = 1.30` para emulsiones estándar (HP5, Tri-X, Fomapan, Lomo, Rollei, etc.)
- `M = 1.25` para T-grain: Kodak T-MAX 100/400 y Ilford Delta 100/400/3200
- `n` = stops de push (1, 2 ó 3)
- Redondeo al 0.5 min más cercano
- Referencia: **Michael Langford** — *The Darkroom Handbook* / *Basic Photography*

Las celdas calculadas están marcadas como `"Langford ×1.3 calc."` en el campo `src`.

### Compensación de temperatura

```
T_temp = T_20°C × factor
```

| Temperatura | Factor |
|---|---|
| 18°C | ×1.20 |
| 19°C | ×1.10 |
| 20°C | ×1.00 (base) |
| 21°C | ×0.90 |
| 22°C | ×0.80 |
| 23°C | ×0.70 |
| 24°C | ×0.60 |

Fuente: Ilford / Kodak (regla estándar de la industria: ±10% por grado)

### Agitación continua

```
T_continuo = T_base × 0.85
```

Fuente: Ilford Film Processing Chart oficial.

### Stand development

Tiempos documentados reales para los reveladores compatibles:

| Revelador | Dilución | Tiempo stand |
|---|---|---|
| Rodinal / R09 | 1+50 | 60 min |
| Rodinal / R09 | 1+100 | 60 min |
| Rodinal / R09 | 1+200 | 120 min |
| HC-110 | Dil. H (1+63) | 25 min |
| HC-110 | Dil. E (1+47) | 25 min |
| XTOL | 1+3 | 45 min |
| D-76 | 1+3 | 45 min |

Para otros reveladores: tiempo experimental = T_base × 5 (marcado como `⚠ experimental`).

---

## Estructura del JSON

```json
{
  "meta": {
    "name": "Labo Los Alos Dev Chart",
    "version": "1.0.0",
    "entries": 666,
    "films": 34,
    "developers": 23,
    "license": "CC0 1.0 Universal"
  },
  "entries": [
    {
      "film": "Ilford HP5 Plus",
      "iso": 400,
      "dev": "D-76",
      "dil": "1+1",
      "t20": 9.5,
      "t18": 11.5,
      "t21": 8.5,
      "t24": 5.5,
      "p1_20c": 12.0,
      "p2_20c": 15.5,
      "p3_20c": 20.0,
      "src": "Ilford Film Processing Chart 2017"
    }
  ]
}
```

**Campos del JSON:**

| Campo | Tipo | Descripción |
|---|---|---|
| `film` | string | Nombre de la película |
| `iso` | number | Sensibilidad nominal |
| `dev` | string | Revelador |
| `dil` | string | Dilución |
| `t20` | number | Tiempo base en minutos a 20°C |
| `t18`, `t21`, `t24` | number | Tiempos a otras temperaturas (cuando existen datos directos) |
| `p1_20c`, `p2_20c`, `p3_20c` | number | Push +1, +2, +3 stops a 20°C |
| `src` | string | Fuente del dato |
| `romek` | boolean | `true` si es revelador Romek Argentina |

---

## La app web (Android)

`labo-los-alos.html` es una PWA completa que funciona offline. Para convertirla en APK Android:

```bash
# Instalar dependencias
npm install @capacitor/core @capacitor/cli @capacitor/android

# Inicializar proyecto
npx cap init "Labo Los Alos" "com.labololosalos.devchart"

# Copiar el HTML
cp labo-los-alos.html www/index.html

# Agregar Android
npx cap add android

# Buildear
npx cap sync
npx cap open android
# En Android Studio: Build → Generate Signed APK
```

---

## La app Excel (VBA)

Para activar los combos en cascada:

1. Abrir `LaboLosAlos_DevChart_APP.xlsx` en Excel
2. **Guardar como** → `Libro de Excel habilitado para macros (.xlsm)`
3. **Alt + F11** → clic derecho en `ThisWorkbook` → **Importar archivo** → seleccionar `LaboLosAlos_DevChart_Macros.bas`
4. Cerrar VBE → Guardar

---

## Reveladores Romek Argentina

Este repositorio contiene la primera documentación pública conocida de los reveladores **Romek**, fabricante argentino:

| Revelador | Carácter | Uso | Factor push | Base ISO 400 |
|---|---|---|---|---|
| **PQ6** | Equilibrado | Todo uso | ×1.30 | 8:00 min |
| **PQ7** | Más contraste | Push moderado | ×1.30 | 7:30 min |
| **PQ9** | Muy activo | Push / contraste fuerte | ×1.25 | 6:30 min |
| **R09** | Alta acutancia | Artístico / grano visible | ×1.30 | Equivalente Rodinal |

> ⚠️ Diluciones de PQ6, PQ7 y PQ9 pendientes de confirmación con Romek Argentina.  
> R09 usa diluciones 1+25 y 1+50 equivalentes a Rodinal.

---

## Contribuir

¿Tenés datos de revelado que no están en la base? Abrí un **Issue** o un **Pull Request** con:

- Película y revelador
- Tiempo exacto en minutos a 20°C
- Fuente (datasheet, carton, guía oficial)

Solo aceptamos datos con fuente verificable. No se aceptan datos de bases de datos con copyright (Digital Truth, Darkroom Solutions, etc.).

---

## Equivalencias de reveladores

Reveladores químicamente idénticos (fuente: darkroom-solutions.com/notes):

- **XTOL** = Fomadon Excel = Adox XT-3 = Bellini Eco-Film = LegacyPro EcoPro
- **Rodinal** = Fomadon R09 = Compard R09 = Calbe R09 = ORWO R09 = Blazinal = Adox Adonal
- **D-76** = ID-11 = Arista 76 = Calbe F19 = Silberra S-76
- **HC-110** = Bellini Euro HC = LegacyPro L110
- **D-96** = Bellini D96

---

## Licencia

**CC0 1.0 Universal** — Este trabajo está dedicado al dominio público.  
Podés copiar, modificar, distribuir y usarlo para cualquier propósito, incluso comercial, sin pedir permiso.

[Ver licencia completa](LICENSE)

---

*Dev Chart by Labo Los Alos · 2026 · Buenos Aires, Argentina*
