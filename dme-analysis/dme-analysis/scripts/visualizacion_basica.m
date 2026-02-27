%% script: visualizacion_basica.m
% Visualizaciones básicas de los datos DME

clear; clc;
fprintf('============================================================\n');
fprintf('📈 GENERANDO VISUALIZACIONES DME\n');
fprintf('============================================================\n');

% Cargar datos si es necesario
if ~exist('data', 'var')
    fprintf('\n📥 Cargando datos...\n');
    data = load_dme_data('EstudioDME.xlsx');
end

% Crear carpeta para figuras si no existe
if ~exist('figures', 'dir')
    mkdir('figures');
    fprintf('📁 Carpeta "figures" creada\n');
else
    fprintf('📁 Carpeta "figures" ya existe\n');
end

% Crear figura con subplots
figure('Position', [100 100 1400 900]);

% 1. Retardo DME
subplot(3,3,1);
plot(data.Fecha, data.Retardo, 'b.-', 'MarkerSize', 6, 'LineWidth', 1);
hold on;
yline(56, 'r--', 'LineWidth', 1.5);
yline(55, 'g--', 'LineWidth', 1);
yline(57, 'g--', 'LineWidth', 1);
title('Retardo DME (µs)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('µs');
xlabel('Fecha');
legend('Mediciones', 'Nominal (56)', 'Tolerancia -', 'Tolerancia +', ...
       'Location', 'best', 'FontSize', 8);
grid on;
grid minor;

% 2. Frecuencia
subplot(3,3,2);
plot(data.Fecha, data.Frecuencia, 'r.-', 'MarkerSize', 6, 'LineWidth', 1);
hold on;
yline(1078, 'k--', 'LineWidth', 1.5);
yline(1077.98, 'g--', 'LineWidth', 1);
yline(1078.02, 'g--', 'LineWidth', 1);
title('Frecuencia (MHz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('MHz');
xlabel('Fecha');
grid on;
grid minor;

% 3. Potencia
subplot(3,3,3);
plot(data.Fecha, data.Potencia, 'g.-', 'MarkerSize', 6, 'LineWidth', 1);
hold on;
yline(800, 'r--', 'LineWidth', 1.5);
title('Potencia (W)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('W');
xlabel('Fecha');
legend('Potencia', 'Mínimo 800W', 'Location', 'best', 'FontSize', 8);
grid on;
grid minor;

% 4. Tiempo de Subida
subplot(3,3,4);
plot(data.Fecha, data.TiempoSubida, 'm.-', 'MarkerSize', 6, 'LineWidth', 1);
hold on;
yline(2.5, 'k--', 'LineWidth', 1.5);
yline(1.5, 'g--', 'LineWidth', 1);
yline(3.0, 'g--', 'LineWidth', 1);
title('Tiempo de Subida (µs)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('µs');
xlabel('Fecha');
grid on;
grid minor;

% 5. Ancho de Pulso
subplot(3,3,5);
plot(data.Fecha, data.AnchoPulso, 'c.-', 'MarkerSize', 6, 'LineWidth', 1);
hold on;
yline(3.5, 'k--', 'LineWidth', 1.5);
yline(3.0, 'g--', 'LineWidth', 1);
yline(4.0, 'g--', 'LineWidth', 1);
title('Ancho de Pulso (µs)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('µs');
xlabel('Fecha');
grid on;
grid minor;

% 6. Tiempo de Bajada
subplot(3,3,6);
plot(data.Fecha, data.TiempoBajada, 'b.-', 'MarkerSize', 6, 'LineWidth', 1);
hold on;
yline(2.5, 'k--', 'LineWidth', 1.5);
yline(1.5, 'g--', 'LineWidth', 1);
yline(3.5, 'g--', 'LineWidth', 1);
title('Tiempo de Bajada (µs)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('µs');
xlabel('Fecha');
grid on;
grid minor;

% 7. Separación entre impulsos
subplot(3,3,7);
plot(data.Fecha, data.Separacion, 'k.-', 'MarkerSize', 6, 'LineWidth', 1);
hold on;
yline(30, 'k--', 'LineWidth', 1.5);
yline(29.75, 'g--', 'LineWidth', 1);
yline(30.25, 'g--', 'LineWidth', 1);
title('Separación entre Impulsos (µs)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('µs');
xlabel('Fecha');
grid on;
grid minor;

% 8. Histograma de Retardo
subplot(3,3,8);
histogram(data.Retardo, 30, 'FaceColor', 'b', 'EdgeColor', 'k', 'FaceAlpha', 0.7);
hold on;
xline(56, 'r--', 'LineWidth', 1.5);
xline(55, 'g--');
xline(57, 'g--');
title('Distribución de Retardo', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Retardo (µs)');
ylabel('Frecuencia');
grid on;

% 9. Eventos de mantenimiento
subplot(3,3,9);
eventos = find(~ismissing(data.Observaciones) & data.Observaciones ~= "");
for i = 1:length(eventos)
    idx = eventos(i);
    plot(data.Fecha(idx), 1, 'rs', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    hold on;
    text(data.Fecha(idx), 1.1, sprintf('E%d', i), ...
         'HorizontalAlignment', 'center', 'FontSize', 8, 'Rotation', 45);
end
xlim([min(data.Fecha), max(data.Fecha)]);
ylim([0.8 1.3]);
set(gca, 'YTick', []);
title('Eventos de Mantenimiento', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Fecha');
grid on;

% Título general
sgtitle('📡 Evolución Temporal de Parámetros DME (2015-2020)', 'FontSize', 14, 'FontWeight', 'bold');

% VERIFICAR QUE LA CARPETA EXISTE ANTES DE GUARDAR
if ~exist('figures', 'dir')
    mkdir('figures');
    fprintf('📁 Carpeta figures creada en: %s\n', pwd);
end

% Guardar figura - VERSIÓN CORREGIDA
try
    saveas(gcf, 'figures/evolucion_temporal.png');
    fprintf('✅ Figura guardada correctamente en: figures/evolucion_temporal.png\n');
    
    % Verificar que el archivo existe
    if exist('figures/evolucion_temporal.png', 'file')
        fprintf('   ✅ Archivo verificado en disco\n');
    else
        fprintf('   ⚠️ El archivo no se encuentra después de guardar\n');
    end
catch ME
    fprintf('❌ Error al guardar: %s\n', ME.message);
    fprintf('   Intentando guardar con ruta completa...\n');
    
    % Intentar con ruta completa
    ruta_completa = fullfile(pwd, 'figures', 'evolucion_temporal.png');
    saveas(gcf, ruta_completa);
    fprintf('✅ Guardado en: %s\n', ruta_completa);
end

% Mostrar mensaje final
fprintf('\n📊 Visualización completada. La figura está abierta en pantalla.\n');
fprintf('   Carpeta de trabajo actual: %s\n', pwd);
fprintf('============================================================\n');

% Listar archivos en figures para verificar
fprintf('\n📁 Archivos en carpeta figures:\n');
dir figures