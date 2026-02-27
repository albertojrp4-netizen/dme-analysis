%% script: analisis_basico.m
% Análisis exploratorio básico de datos DME

clear; clc;
fprintf('============================================================\n');
fprintf('📊 ANÁLISIS EXPLORATORIO DE DATOS DME\n');
fprintf('============================================================\n');

% 1. Cargar datos (si no están ya en el workspace)
if ~exist('data', 'var')
    fprintf('\n📥 Cargando datos...\n');
    data = load_dme_data('EstudioDME.xlsx');
end

% 2. Estadísticas descriptivas
fprintf('\n📈 ESTADÍSTICAS DESCRIPTIVAS:\n');
fprintf('%-20s %10s %10s %10s %10s\n', 'Parámetro', 'Media', 'Std', 'Mín', 'Máx');
fprintf('------------------------------------------------------------\n');

parametros = {'Retardo', 'Frecuencia', 'Potencia', 'TiempoSubida', ...
              'AnchoPulso', 'TiempoBajada', 'Separacion'};

for i = 1:length(parametros)
    p = parametros{i};
    valores = data.(p);
    fprintf('%-20s %10.2f %10.3f %10.2f %10.2f\n', ...
            p, mean(valores), std(valores), min(valores), max(valores));
end

% 3. Verificar valores dentro de tolerancia
fprintf('\n✅ VERIFICACIÓN DE TOLERANCIAS:\n');
tolerancias.Retardo = [55, 57];
tolerancias.Frecuencia = [1077.98, 1078.02];
tolerancias.TiempoSubida = [1.5, 3.0];
tolerancias.AnchoPulso = [3.0, 4.0];
tolerancias.TiempoBajada = [1.5, 3.5];
tolerancias.Separacion = [29.75, 30.25];
tolerancias.Potencia = [800, 1200];  % Añadí límite superior

for i = 1:length(parametros)
    p = parametros{i};
    valores = data.(p);
    
    if strcmp(p, 'Potencia')
        ok = valores >= tolerancias.(p)(1);
    else
        ok = valores >= tolerancias.(p)(1) & valores <= tolerancias.(p)(2);
    end
    
    porcentaje_ok = sum(ok) / length(valores) * 100;
    fprintf('%-20s: %6.2f%% dentro de tolerancia\n', p, porcentaje_ok);
end

% 4. Identificar eventos de mantenimiento
eventos = find(~ismissing(data.Observaciones) & data.Observaciones ~= "");
fprintf('\n🔧 EVENTOS DE MANTENIMIENTO: %d encontrados\n', length(eventos));

if length(eventos) > 0
    fprintf('\n%-15s %-12s %s\n', 'Fecha', 'Parámetro', 'Observación');
    fprintf('------------------------------------------------------------\n');
    
    for i = 1:length(eventos)
        idx = eventos(i);
        % Buscar qué parámetro está fuera de rango en ese evento
        parametro_afectado = '';
        for j = 1:length(parametros)
            p = parametros{j};
            valor = data.(p)(idx);
            if strcmp(p, 'Potencia')
                if valor < tolerancias.(p)(1)
                    parametro_afectado = p;
                    break;
                end
            else
                if valor < tolerancias.(p)(1) || valor > tolerancias.(p)(2)
                    parametro_afectado = p;
                    break;
                end
            end
        end
        
        fprintf('%-15s %-12s %s\n', datestr(data.Fecha(idx)), ...
                parametro_afectado, data.Observaciones{idx});
    end
end

% 5. Resumen ejecutivo
fprintf('\n============================================================\n');
fprintf('📋 RESUMEN EJECUTIVO:\n');
fprintf('   Período analizado: %s a %s\n', datestr(min(data.Fecha)), datestr(max(data.Fecha)));
fprintf('   Total mediciones: %d\n', height(data));
fprintf('   Parámetros analizados: %d\n', length(parametros));
fprintf('   Eventos de mantenimiento: %d\n', length(eventos));

% Encontrar parámetro con menor desviación estándar
stds = [];
for i = 1:length(parametros)
    stds(i) = std(data.(parametros{i}));
end
[~, idx_min] = min(stds);
fprintf('   Parámetro más estable: %s (std=%.3f)\n', ...
        parametros{idx_min}, stds(idx_min));

fprintf('============================================================\n');
fprintf('\n✅ Análisis básico completado\n');