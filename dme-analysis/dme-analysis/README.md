# Análisis de Datos DME (Distance Measuring Equipment)

[![MATLAB](https://img.shields.io/badge/MATLAB-Online-orange)](https://www.mathworks.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

## Descripción del Proyecto

Análisis exhaustivo de datos de equipos DME (Distance Measuring Equipment) utilizados en navegación aérea. Este proyecto procesa mediciones mensuales de 7 parámetros críticos durante el período 2015-2020, detecta anomalías y evalúa el impacto de los cambios de tarjeta en el rendimiento del equipo.

### Objetivos
- Analizar la evolución temporal de los parámetros DME
- Detectar valores fuera de tolerancia
- Evaluar el impacto de cambios de tarjeta
- Identificar patrones de degradación
- Generar reportes automáticos

## Parámetros Analizados

| Parámetro | Valor Nominal | Tolerancia | Unidades |
|-----------|--------------|------------|----------|
| Retardo DME | 56 | [55, 57] | µs |
| Frecuencia | 1078 | [1077.98, 1078.02] | MHz |
| Tiempo de Subida | 2.5 | [1.5, 3.0] | µs |
| Ancho del Pulso | 3.5 | [3.0, 4.0] | µs |
| Tiempo de Bajada | 2.5 | [1.5, 3.5] | µs |
| Separación | 30 | [29.75, 30.25] | µs |
| Potencia | 1000 | ≥ 800 | W |

## Hallazgos Principales

✅ **5 anomalías detectadas** que coinciden exactamente con eventos de mantenimiento:

| Fecha | Parámetro Afectado | Evento |
|-------|-------------------|--------|
| Marzo 2016 | Tiempo Subida, Tiempo Bajada | Cambio tarjeta TX Video |
| Noviembre 2018 | Retardo, Ancho Pulso, Separación | Cambio tarjeta TX Controller |

## Tecnologías Utilizadas

- **MATLAB Online** (R2024a)
- Statistics and Machine Learning Toolbox
- Signal Processing Toolbox
- Git / GitHub

## Estructura del Proyecto

dme-analysis/
├── 📁 scripts/ # Código fuente MATLAB
│ ├── load_dme_data.m # Carga de datos
│ ├── analisis_basico.m # Estadísticas descriptivas
│ ├── visualizacion_basica.m # Visualizaciones
│ ├── detectar_anomalias.m # Detección de anomalías
│ └── ejecutar_analisis_completo.m # Script principal
├── 📁 data/ # Datos de entrada
│ └── EstudioDME.xlsx
├── 📁 figures/ # Figuras generadas
│ ├── evolucion_temporal.png
│ └── anomalias_detectadas.png
├── 📁 results/ # Resultados numéricos
└── 📁 docs/ # Documentación adicional



## Cómo Ejecutar

```matlab
% 1. En MATLAB Online, navega a la carpeta
cd dme-analysis

% 2. Ejecutar el análisis completo
ejecutar_analisis_completo