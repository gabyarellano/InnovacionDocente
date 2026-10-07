%[text] # Enfriamiento del Café: Modelado del Cambio de Temperatura
%[text] En esta actividad, usarás datos medidos de la temperatura del café para modelar su enfriamiento a lo largo del tiempo y comparar cómo distintos tipos de tazas afectan el tiempo que tarda el café en alcanzar una temperatura adecuada para beber.
%[text] **Objetivo** **de** **aprendizaje:** Aprender a modelar datos de enfriamiento utilizando MATLAB.
%[text:tableOfContents]{"heading":"Contents"}
%[text] - Explora los datos experimentales.
%[text] - Ajusta un modelo de enfriamiento.
%[text] - Compara diferentes tipos de tazas.
%[text] - Crea una animación del proceso de enfriamiento.
%[text] - Resume tus resultados. \
%%
%[text] ## **Pregunta inicial**
%[text] Una taza de café comienza a **85.6 °C** en una habitación a **21.7 °C**. Si **60 °C** es una temperatura adecuada para beberlo, ¿cuánto tiempo crees que debes esperar antes de tomarlo?
%[text] **Antes de ejecutar el modelo, escribe tu predicción:**
%[text] *Creo que el café alcanzará los* ***60 °C*** *después de aproximadamente \_\_\_\_\_\_ minutos porque \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_.*
%%
%[text] ## **Datos medidos del café**
%[text] Las mediciones que aparecen a continuación se obtuvieron de una taza de café mientras se enfriaba. La temperatura ambiente era de **21.7 °C**. Observa los datos antes de comenzar el análisis.
tiempoMinutos = [0 1 2 3 8 13 18 23 28 33 38 43 48]';
temperaturaCafeC = [85.6, 81.7, 79.4, 77.2, 68.9, 62.2, 57.2, 52.8, 48.9, 46.7, 43.9, 41.7, 40.0]';
temperaturaAmbienteC = 21.7;
coffeeData = table(tiempoMinutos,temperaturaCafeC,VariableNames=["tiempoMinutos","temperaturaCafeC"])
plot(tiempoMinutos,temperaturaCafeC)
grid on
xlabel("Tiempo (minutos)")
ylabel("Temperatura del café (Grados C)")
title("Temperatura medida del café")
subtitle("La temperatura disminuye rápidamente al principio y luego más lentamente")
%%
%[text] ## Ajusta un modelo de enfriamiento
%[text] La **ley de enfriamiento de Newton** describe cómo la temperatura de un objeto se acerca gradualmente a la temperatura ambiente con el paso del tiempo.
%[text]{"align":"center"} $ T(t) = T\_{room} + (T\_0 - T\_{room})e^{-kt} $
%[text] El siguiente código estima la **constante de enfriamiento** *k* a partir de los datos experimentales y predice cuándo el café alcanzará la temperatura objetivo para beberlo
temperaturaObjetivoC = 60;
diferenciaTemperaturaC = temperaturaCafeC - temperaturaAmbienteC;
coeficientesAjuste = polyfit(tiempoMinutos, log(diferenciaTemperaturaC), 1);
tasaEnfriamientoPorMin = -coeficientesAjuste(1);
diferenciaInicialEstimadaC = exp(coeficientesAjuste(2));
tiempoModelo = linspace(0, max(tiempoMinutos), 200);
temperaturaModeloC = temperaturaAmbienteC + ...
    diferenciaInicialEstimadaC .* exp(-tasaEnfriamientoPorMin .* tiempoModelo);
minutosHastaObjetivo = -log( ...
    (temperaturaObjetivoC - temperaturaAmbienteC) / diferenciaInicialEstimadaC) ...
    / tasaEnfriamientoPorMin;
temperaturaDespues30MinC = temperaturaAmbienteC + ...
    diferenciaInicialEstimadaC * exp(-tasaEnfriamientoPorMin * 30);
plot(tiempoMinutos, temperaturaCafeC, "o", ...
    tiempoModelo, temperaturaModeloC, "-", "LineWidth", 1.5)

grid on
xlabel("Tiempo (minutos)")
ylabel("Temperatura del café (°C)")
title("Datos experimentales y modelo de enfriamiento ajustado")
legend("Datos experimentales", "Modelo de enfriamiento", ...
    Location="northeast")
yline(temperaturaObjetivoC, ":", "Temperatura objetivo")
resumenModelo = table( ...
    tasaEnfriamientoPorMin, minutosHastaObjetivo, temperaturaDespues30MinC, ...
    VariableNames=["TasaEnfriamientoPorMin", ...
    "MinutosHasta60C", ...
    "TemperaturaDespues30MinC"])
%[text] Según el modelo ajustado, el café alcanza la temperatura objetivo de 60 °C después del tiempo estimado que se muestrtemperaturaAmbienteCa en la tabla.
%%
%[text] ## Compara diferentes tipos de tazas
%[text] Los datos experimentales corresponden a una sola taza de café. Los escenarios que se muestran a continuación utilizan la tasa de enfriamiento obtenida del modelo como punto de partida y luego la modifican para explorar qué podría ocurrir con distintos tipos de tazas.
%[text] Los valores utilizados en estos escenarios son únicamente ilustrativos y **no deben interpretarse como especificaciones reales de productos**.
configuracionEscenarios = table( ...
    ["Taza convencional"; "Taza térmica"; "Vaso de papel"], ...
    ["Convencional"; "Térmica"; "Papel"], ...
    [1.00; 0.55; 1.30], ...
    ["Escenario de referencia basado en los datos experimentales"; ...
    "Enfriamiento más lento porque el aislamiento reduce la transferencia de calor"; ...
    "Enfriamiento más rápido en este modelo simplificado para el aula"], ...
    VariableNames=["Escenario","EtiquetaCorta","MultiplicadorTasa","Interpretacion"]);

configuracionEscenarios.TasaEnfriamientoPorMin = ...
    tasaEnfriamientoPorMin .* configuracionEscenarios.MultiplicadorTasa;

tiempoEscenarios = (0:0.5:60)';

temperaturaEscenariosC = temperaturaAmbienteC + ...
    (temperaturaCafeC(1) - temperaturaAmbienteC) .* ...
    exp(-tiempoEscenarios * configuracionEscenarios.TasaEnfriamientoPorMin');

minutosHastaObjetivo = log( ...
    (temperaturaCafeC(1) - temperaturaAmbienteC) / ...
    (temperaturaObjetivoC - temperaturaAmbienteC)) ./ ...
    configuracionEscenarios.TasaEnfriamientoPorMin;

temperaturaDespues30MinC = temperaturaAmbienteC + ...
    (temperaturaCafeC(1) - temperaturaAmbienteC) .* ...
    exp(-30 * configuracionEscenarios.TasaEnfriamientoPorMin);

resultadosEscenarios = table( ...
    configuracionEscenarios.Escenario, ...
    configuracionEscenarios.TasaEnfriamientoPorMin, ...
    minutosHastaObjetivo, ...
    temperaturaDespues30MinC, ...
    VariableNames=["Escenario", ...
    "TasaEnfriamientoPorMin", ...
    "MinutosHasta60C", ...
    "TemperaturaDespues30MinC"])

colororder(paletaEscenarios(height(configuracionEscenarios)))
plot(tiempoEscenarios, temperaturaEscenariosC, LineWidth=1.8)
grid on

xlabel("Tiempo (minutos)")
ylabel("Temperatura del café (°C)")
title("Comparación de escenarios de enfriamiento")
subtitle("Las distintas tasas de enfriamiento producen diferentes tiempos de espera")
legend(configuracionEscenarios.Escenario, Location="northeast")
yline(temperaturaObjetivoC, ":", "Temperatura objetivo")
%[text] Compara los resultados de cada escenario y responde las siguientes preguntas:
%[text] - ¿Qué escenario alcanza primero la **temperatura** **objetivo** **de** **60** **°C**?
%[text] - ¿Qué escenario mantiene la temperatura más alta después de **30** **minutos**? \
%[text] **Explica** **tus** **respuestas** **utilizando** **la** **gráfica** **y** **la** **tabla** **de** **resultados.**
%%
%[text] ## Resumen
%[text] Los datos experimentales muestran que la temperatura del café sigue un patrón de enfriamiento en el que se aproxima gradualmente a la temperatura ambiente.
%[text] Al comparar los distintos escenarios, observaste que una **tasa de enfriamiento mayor** permite que el café alcance la **temperatura objetivo** más rápidamente, mientras que una **tasa de enfriamiento menor** mantiene el café caliente durante más tiempo.
%[text] Una limitación de este análisis es que los escenarios de las distintas tazas están simplificados. Para obtener conclusiones más sólidas sobre una taza convencional, una taza térmica o un vaso de papel reales, necesitarías recopilar y analizar datos experimentales para cada uno de esos casos.
%%
%[text] ## **Funciones auxiliares**
%[text] Estas funciones se utilizan para la conversión de temperatura, la definición de colores para los escenarios y la creación de la animación.
function paleta = paletaEscenarios(numeroEscenarios)

    paletaBase = [ ...
        0.70 0.26 0.12;
        0.04 0.35 0.70;
        0.43 0.43 0.43;
        0.10 0.52 0.30;
        0.58 0.30 0.70;
        0.84 0.55 0.10];
    
    if numeroEscenarios <= size(paletaBase,1)
        paleta = paletaBase(1:numeroEscenarios,:);
    else
        paleta = lines(numeroEscenarios);
        paleta(1:size(paletaBase,1),:) = paletaBase;
    end

end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
