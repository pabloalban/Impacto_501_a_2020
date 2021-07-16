message( '\tCalculando escenarios del balance para IVM' )

# Carga --------------------------------------------------------------------------------------------
load( paste0( parametros$RData, 'IESS_macro_estudio.RData' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros', 'Hipotesis' ) ) ] )

# Factores de calibración --------------------------------------------------------------------------
# Incluimos los factores de calibración siguientes en cada escenario:
# esc$calibra_aux_fun <- 0.275  para reflejar el hecho que no todos los fallecidos producen auxilio de funerales
# esc$calibra_pen_vej <- 1.075  para acercarnos a la realidad observada en el primer año de proyección
# esc$calibra_pen_inv <- 0.70   para acercarnos a la realidad observada en el primer año de proyección

# Escenario 1: CD 261-------------------------------------------------------------------------------
esc <- new.env()
esc$nombre <- 'escenario_1'
message( '\t\t\t', esc$nombre )

esc$V0 <- 6543201759.76
esc$aporte_estado <- 0.28
esc$porcentaje_gasto <- 0.04
esc$calibra_aux_fun <- 0.275 
esc$calibra_apo <- 1.0
esc$calibra_pen_vej <- 1.105
esc$calibra_pen_inv <- 0.70

esc$apo_act <- data.table( t = 0:parametros$horizonte,
                           i_a = 0.0625,
                           i_r = Hipotesis[ 4, 2 ],
                           i_sbu = Hipotesis[ 5, 2 ],
                           i_f = Hipotesis[ 7, 2 ],
                           i_p = Hipotesis[ 7, 2 ],
                           por_apo = c( rep( 0.0974, 41 ) ) + 0.001,
                           por_apo_pen_vej = 0.0276,
                           por_apo_pen_inv = 0.0276,
                           por_apo_pen_mon = 0.0276 )

parametros_lista <- c( 'parametros_lista', 'esc', 'Hipotesis' )
#source( 'R/305_proyeccion_salarios.R', encoding = 'UTF-8', echo = FALSE )
#source( 'R/ivm/300_proyeccion_beneficios_ivm.R', encoding = 'UTF-8', echo = FALSE )
#source( 'R/ivm/301_proyeccion_beneficios_calibrado_ivm.R', encoding = 'UTF-8', echo = FALSE )
source( 'R/302_calculo_balance_ivm.R', encoding = 'UTF-8', echo = FALSE )
save( esc, file = paste0( parametros$RData_seg, 'IESS_IVM_configuracion_', esc$nombre, '.RData' ) )
rm( esc )

# Escenario 2 --------------------------------------------------------------------------------------
esc <- new.env()
esc$nombre <- 'escenario_2'
message( '\t\t\t', esc$nombre )

esc$V0 <- 6543201759.76
esc$aporte_estado <- 0.28
esc$porcentaje_gasto <- 0.04
esc$calibra_aux_fun <- 0.275
esc$calibra_apo <- 1.0
esc$calibra_pen_vej <- 1.105
esc$calibra_pen_inv <- 0.70
esc$apo_act <- data.table( t = 0:parametros$horizonte,
                           i_a = 0.0625,
                           i_r = Hipotesis[ 4, 2 ],
                           i_sbu = Hipotesis[ 5, 2 ],
                           i_f = Hipotesis[ 7, 2 ],
                           i_p = Hipotesis[ 7, 2 ],
                           por_apo = c( 0.0766, 0.0886, 0.0986, rep( 0.1046, 38 ) ) + 0.001,
                           por_apo_pen_vej = 0.0276,
                           por_apo_pen_inv = 0.0276,
                           por_apo_pen_mon = 0.0276 )

parametros_lista <- c( 'parametros_lista', 'esc', 'Hipotesis' )
#source( 'R/305_proyeccion_salarios.R', encoding = 'UTF-8', echo = FALSE )
#source( 'R/ivm/300_proyeccion_beneficios_ivm.R', encoding = 'UTF-8', echo = FALSE )
#source( 'R/ivm/301_proyeccion_beneficios_calibrado_ivm.R', encoding = 'UTF-8', echo = FALSE )
source( 'R/302_calculo_balance_ivm.R', encoding = 'UTF-8', echo = FALSE )
save( esc, file = paste0( parametros$RData_seg, 'IESS_IVM_configuracion_', esc$nombre, '.RData' ) )
rm( esc )

# Cálculo de primas y análisis de ratios para todos los escenarios ---------------------------------
message( '\tCalculando primas y análisis de ratios' )
source( 'R/304_calculo_prima_ivm.R', encoding = 'UTF-8', echo = FALSE )

#Limpiar Ram----------------------------------------------------------------------------------------
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()
