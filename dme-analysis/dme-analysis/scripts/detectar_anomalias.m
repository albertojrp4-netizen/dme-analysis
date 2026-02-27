%% script: detectar_anomalias.m
% Detectar valores fuera de tolerancia en datos DME

clear; clc;
fprintf('============================================================\n');
fprintf('🚨 DETECTANDO ANOMALÍAS EN DATOS DME\n');
fprintf('============================================================\n');

% Cargar datos si es necesario
if ~exist('data', 'var')
    fprintf('\n📥 Cargando datos...\n');
    data = load_dme_data('EstudioDME.xlsx');
end

% Definir tolerancias
tolerancias.Retardo = [55, 57];
tolerancias.Frecuencia = [1077.98, 1078.02];
tolerancias.TiempoSubida = [1.5, 3.0];
tolerancias.AnchoPulso = [3.0, 4.0];
tolerancias.TiempoBajada = [1.5, 3.5];
tolerancias.Separacion = [29.75, 30.25];
tolerancias.Potencia = [800, 1200];

% Lista de parámetros a analizar
parametros = fieldnames(tolerancias);
fprintf('\n📋 Analizando %d parámetros...\n', length(parametros));

% Tabla para almacenar anomalías
anomalias = table();

% Analizar cada parámetro
for i = 1:length(parametros)
    p = parametros{i};
    valores = data.(p);
    
    % Determinar qué valores están fuera de tolerancia
    if strcmp(p, 'Potencia')
        fuera_rango = valores < tolerancias.(p)(1) | valores > tolerancias.(p)(2);
        limite_str = sprintf('[%.0f, %.0f]', tolerancias.(p)(1), tolerancias.(p)(2));
    else
        fuera_rango = valores < tolerancias.(p)(1) | valores > tolerancias.(p)(2);
        limite_str = sprintf('[%.2f, %.2f]', tolerancias.(p)(1), tolerancias.(p)(2));
    end
    
    indices = find(fuera_rango);
    
    % Si hay anomalías, guardarlas
    for j = 1:length(indices)
        idx = indices(j);
        nueva_fila = table();
        nueva_fila.Fecha = data.Fecha(idx);
        nueva_fila.Parametro = {p};
        nueva_fila.Valor = valores(idx);
        nueva_fila.Limite = {limite_str};
        nueva_fila.Observacion = data.Observaciones(idx);
        anomalias = [anomalias; nueva_fila];
    end
end

% Mostrar resultados
fprintf('============================================================\n');
if height(anomalias) > 0
    fprintf('🚨 SE DETECTARON %d ANOMALÍAS:\n', height(anomalias));
    fprintf('============================================================\n');
    
    % Mostrar tabla de anomalías
    for i = 1:height(anomalias)
        fprintf('%d. %s | %-15s | Valor: %.2f | Límite: %s | Obs: %s\n', ...
                i, datestr(anomalias.Fecha(i)), anomalias.Parametro{i}, ...
                anomalias.Valor(i), anomalias.Limite{i}, ...
                anomalias.Observacion{i});
    end
    
    % Crear figura de anomalías
    figure('Position', [100 100 1200 500]);
    
    % Gráfico de retardo con anomalías marcadas
    subplot(1,2,1);
    plot(data.Fecha, data.Retardo, 'b.-', 'LineWidth', 1, 'MarkerSize', 6);
    hold on;
    
    % Marcar anomalías de retardo
    idx_retardo = find(strcmp(anomalias.Parametro, 'Retardo'));
    for k = 1:length(idx_retardo)
        idx = find(data.Fecha == anomalias.Fecha(idx_retardo(k)));
        if ~isempty(idx)
            plot(data.Fecha(idx), data.Retardo(idx), 'ro', ...
                 'MarkerSize', 10, 'LineWidth', 2);
        end
    end
    
    yline(56, 'r--', 'LineWidth', 1.5);
    yline(55, 'g--');
    yline(57, 'g--');
    title('Anomalías en Retardo DME');
    xlabel('Fecha');
    ylabel('Retardo (µs)');
    legend('Mediciones', 'Anomalías', 'Nominal', 'Tolerancias', ...
           'Location', 'best');
    grid on;
    
    % Gráfico de potencia con anomalías marcadas
    subplot(1,2,2);
    plot(data.Fecha, data.Potencia, 'g.-', 'LineWidth', 1, 'MarkerSize', 6);
    hold on;
    
    % Marcar anomalías de potencia
    idx_potencia = find(strcmp(anomalias.Parametro, 'Potencia'));
    for k = 1:length(idx_potencia)
        idx = find(data.Fecha == anomalias.Fecha(idx_potencia(k)));
        if ~isempty(idx)
            plot(data.Fecha(idx), data.Potencia(idx), 'ro', ...
                 'MarkerSize', 10, 'LineWidth', 2);
        end
    end
    
    yline(800, 'r--', 'LineWidth', 1.5);
    title('Anomalías en Potencia');
    xlabel('Fecha');
    ylabel('Potencia (W)');
    legend('Mediciones', 'Anomalías', 'Mínimo 800W', 'Location', 'best');
    grid on;
    
    sgtitle('🚨 Detección de Anomalías en Datos DME');
    
    % Guardar figura
    if ~exist('figures', 'dir')
        mkdir('figures');
    end
    saveas(gcf, 'figures/anomalias_detectadas.png');
    fprintf('\n✅ Figura guardada: figures/anomalias_detectadas.png\n');
    
else
    fprintf('✅ No se detectaron anomalías. Todos los valores están dentro de tolerancia.\n');
end

fprintf('============================================================\n');
fprintf('✅ Análisis de anomalías completado\n');