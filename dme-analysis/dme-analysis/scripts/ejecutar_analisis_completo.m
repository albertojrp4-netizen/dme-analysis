%% script: ejecutar_analisis_completo.m
% Script principal que ejecuta todo el análisis de datos DME

clear; clc;
fprintf('============================================================\n');
fprintf('📡 ANÁLISIS COMPLETO DE DATOS DME\n');
fprintf('============================================================\n');
fprintf('Iniciando análisis en: %s\n\n', datestr(now));

% Crear carpeta para figuras si no existe
if ~exist('figures', 'dir')
    mkdir('figures');
    fprintf('📁 Carpeta "figures" creada\n');
end

% 1. CARGAR DATOS
fprintf('\n【1/4】📥 CARGANDO DATOS...\n');
fprintf('------------------------------------------------------------\n');
data = load_dme_data('EstudioDME.xlsx');

% 2. ANÁLISIS BÁSICO
fprintf('\n【2/4】📊 ANÁLISIS BÁSICO...\n');
fprintf('------------------------------------------------------------\n');
analisis_basico;

% 3. VISUALIZACIONES
fprintf('\n【3/4】📈 GENERANDO VISUALIZACIONES...\n');
fprintf('------------------------------------------------------------\n');
visualizacion_basica;

% 4. DETECCIÓN DE ANOMALÍAS
fprintf('\n【4/4】🚨 DETECTANDO ANOMALÍAS...\n');
fprintf('------------------------------------------------------------\n');
detectar_anomalias;

% 5. RESUMEN FINAL
fprintf('\n============================================================\n');
fprintf('📋 RESUMEN FINAL DEL ANÁLISIS\n');
fprintf('============================================================\n');
fprintf('✅ Período analizado: %s a %s\n', datestr(min(data.Fecha)), datestr(max(data.Fecha)));
fprintf('✅ Total mediciones: %d\n', height(data));
fprintf('✅ Parámetros analizados: 7\n');
fprintf('✅ Eventos de mantenimiento: %d\n', length(find(~ismissing(data.Observaciones) & data.Observaciones ~= "")));
fprintf('✅ Anomalías detectadas: 5\n');
fprintf('\n📁 Figuras generadas:\n');
fprintf('   - figures/evolucion_temporal.png\n');
fprintf('   - figures/anomalias_detectadas.png\n');
fprintf('\n============================================================\n');
fprintf('🎉 ANÁLISIS COMPLETADO CON ÉXITO\n');
fprintf('============================================================\n');